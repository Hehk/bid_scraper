defmodule AuctionCache.Cache do
  @moduledoc """
  Provides the caching system for auctions
  """
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [
      {:ets_table_name, :auction_cache_table},
      {:log_limit, 1_000}
    ], opts)
  end

  def init(args) do
    [{:ets_table_name, ets_table_name}, {:log_limit, log_limit}] = args
    :ets.new(ets_table_name, [:named_table, :set, :private])

    {:ok, %{log_limit: log_limit, ets_table_name: ets_table_name}}
  end

  def all(), do: GenServer.call(__MODULE__, :all)
  def handle_call(:all, _from, state) do
    %{ets_table_name: ets_table_name} = state
    auctions = ets_table_name
    |> :ets.tab2list
    |> Enum.map(&create_map_auction(&1))

    {:reply, auctions, state}
  end

  def set(auction), do: GenServer.call(__MODULE__, {:set, auction})
  def handle_call({:set, auction}, _from, state) do
    %{ets_table_name: ets_table_name} = state
    formatted_auction = Map.pop(auction, :id)
    true = :ets.insert(ets_table_name, formatted_auction)

    {:reply, true, state}
  end

  def get(id), do: GenServer.call(__MODULE__, {:get, id})
  def handle_call({:get, id}, _from, state) do
    %{ets_table_name: ets_table_name} = state
    auction = ets_table_name
             |> :ets.lookup(id)
             |> create_map_auction

    {:reply, auction, state}
  end

  # creates the format used in the ets for easy id based lookup
  def create_tuble_auction(auction),             do: Map.pop(auction, :id)
  # creates the standard format used throughout the application
  def create_map_auction({id, auction_details}), do: Map.put(auction_details, :id, id)
end
