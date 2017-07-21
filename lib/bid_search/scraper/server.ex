defmodule BidSearch.Scraper.Server do
  @moduledoc """
  Server for managing the scraping
  """
  use GenServer
  alias BidSearch.Scraper
  alias ItemCache.Cache

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def init(args) do
    # updating for initial load
    scrape()

    # prepare future refreshing of cache
    schedule_scrape()

    {:ok, %{updating?: true}}
  end

  def handle_cast(:done_updating, state) do
    {:noreply, %{updating?: false}}
  end

  def updating?, do: GenServer.call(__MODULE__, :updating?)
  def handle_call(:updating?, _from, %{updating?: updating?} = state) do
    {:reply, updating?, state}
  end

  def handle_info(:scrape, state) do
    scrape()
    schedule_scrape()

    {:noreply, %{updating?: true}}
  end

  def schedule_scrape do
    Process.send_after(__MODULE__, :scrape, 1_000 * 60 * 2)
  end

  def scrape do
    Task.start_link fn ->
      # gathering items
      items = Scraper.get_auctions
      |> Enum.map(&Task.async(fn ->
        Scraper.get_items(&1)
      end))
      |> Enum.map(&Task.await(&1, 20_000))
      |> List.flatten
      |> Enum.filter(&Cache.valid_item?(&1))

      Enum.each(items, &Cache.insert(&1))

      IO.puts "Gathered #{length items} items"
      GenServer.cast(__MODULE__, :done_updating)
    end
  end
end
