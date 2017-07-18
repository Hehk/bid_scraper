defmodule BidSearch.Scraper.Server do
  @moduledoc """
  Server for managing the scraping
  """
  use GenServer

  def handle_call(:get_auctions, _from, state) do
    auction_ids = []

    {:reply, auction_ids, state}
  end

  def handle_call({:get_items, auction_ids}, _from, state) do
    new_items = []

    {:reply, new_items, state}
  end

  def handle_call(:is_updating, _from, state) do
    %{is_updating: is_updating} = state

    {:reply, is_updating, state}
  end

  # defines start time of the next update
  def handle_call(:wait, _from, state) do
    %{start_time: start_time} = state
    new_start_time = start_time + 500_000

    {:reply, new_start_time, %{start_time: new_start_time, is_updating: false}}
  end

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def init(args) do
    {:ok, %{start_time: 0, is_updating: true}}
  end
end
