defmodule Scraper.Server do
  @moduledoc """
  Server for managing the scraping
  """
  use GenServer
  alias Scraper
  alias Cache.Auctions
  alias Cache.Items
  require Logger

  @http_limit 20

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def init(_args) do
    # updating for initial load
    scrape()

    # prepare future refreshing of cache
    schedule_scrape()

    {:ok, %{updating?: true}}
  end

  def handle_cast(:done_updating, _state) do
    {:noreply, %{updating?: false}}
  end

  def updating?, do: GenServer.call(__MODULE__, :updating?)
  def handle_call(:updating?, _from, %{updating?: updating?} = state) do
    {:reply, updating?, state}
  end

  def handle_info(:scrape, _state) do
    scrape()
    schedule_scrape()

    {:noreply, %{updating?: true}}
  end

  def schedule_scrape do
    Process.send_after(__MODULE__, :scrape, 1_000 * 60 * 6)
  end

  # there is an issue with letting out too many http requests at once
  def limited_pmap(list, limit, fun) do
    list
    |> Enum.chunk(limit)
    |> Enum.map(fn chunk ->
      chunk
      |> Enum.map(&Task.async(fn -> fun.(&1) end))
      |> Enum.map(&Task.await(&1, 5000))
    end)
    |> List.flatten
  end

  def scrape do
    Task.start_link fn ->
      cached_auction_ids = Auctions.all()
      |> Enum.map(fn (%{id: id}) -> id end)
      |> MapSet.new()

      # get diff between scraped and cached auctions
      new_auction_ids = Scraper.Component.AuctionId.get()
      |> Enum.filter(fn id -> is_bitstring(id) end)
      |> MapSet.new()
      |> MapSet.difference(cached_auction_ids)

      # get auctions from the new ids
      auctions = new_auction_ids
      |> limited_pmap(@http_limit, &Scraper.Component.AuctionDetails.get(&1))
      |> Enum.filter(&Auctions.valid_auction?(&1))

      # get items from the new ids
      items = new_auction_ids
      |> limited_pmap(@http_limit, &Scraper.Component.Items.get(&1))
      |> Enum.filter(&Items.valid_item?(&1))

      # update the cache
      Enum.each(auctions, &Auctions.insert(&1))
      Enum.each(items, &Items.insert(&1))

      Logger.info "Detected #{length MapSet.to_list(new_auction_ids)} new auctions and gathered #{length items} items!"
      GenServer.cast(__MODULE__, :done_updating)
    end
  end
end
