defmodule BidSearch.Scraper.Server do
  @moduledoc """
  Server for managing the scraping
  """
  use GenServer

  def get_auctions, do: GenServer.call(__MODULE__, :get_auctions)
  def get_items(auction_ids), do: GenServer.call(__MODULE__, {:get_items, auction_ids})
  def updating?, do: GenServer.call(__MODULE__, :updating?)
  def wait, do: GenServer.call(__MODULE__, :wait)

  def handle_call(:get_auctions, _from, state) do
    auction_ids = []

    {:reply, auction_ids, state}
  end

  def handle_call({:get_items, auction_ids}, _from, state) do
    new_items = []

    {:reply, new_items, state}
  end

  def handle_call(:updating?, _from, state) do
    %{updating?: updating?} = state

    {:reply, updating?, state}
  end

  # defines start time of the next update
  def handle_call(:wait, _from, state) do
    %{start_time: start_time} = state
    new_start_time = start_time + 500_000

    {:reply, new_start_time, %{start_time: new_start_time, updating?: false}}
  end

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def init(args) do
    {:ok, %{start_time: 0, updating?: true}}
  end
end
