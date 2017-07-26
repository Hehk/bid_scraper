defmodule ItemCache.Cache do
  @moduledoc """
  Provides the caching system for items
  """
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [
      {:ets_table_name, :item_cache_table},
      {:log_limit, 1_000_000}
    ], opts)
  end

  def all do
    GenServer.call(__MODULE__, :all)
  end

  def insert(item) do
    {id, item} = Map.pop(item, :id)
    insert(id, item)
  end

  def insert(id, item) do
    case get(id) do
      nil -> set(id, item)
      _ -> {:error, "Item:#{id} found within store"}
    end
  end

  def get(id) do
    case GenServer.call(__MODULE__, {:get, id}) do
      [] -> nil
      [item] -> item
    end
  end

  def set(item, value) do
    GenServer.call(__MODULE__, {:set, item, value})
  end

  def handle_call(:all, _from, state) do
    %{ets_table_name: ets_table_name} = state
    items = :ets.tab2list(ets_table_name)

    {:reply, items, state}
  end

  def handle_call({:get, id}, _from, state) do
    %{ets_table_name: ets_table_name} = state
    result = :ets.lookup(ets_table_name, id)

    {:reply, result, state}
  end

  def handle_call({:set, item, value}, _from, state) do
    %{ets_table_name: ets_table_name} = state
    true = :ets.insert(ets_table_name, {item, value})

    {:reply, {item, value}, state}
  end

  def init(args) do
    [{:ets_table_name, ets_table_name}, {:log_limit, log_limit}] = args
    :ets.new(ets_table_name, [:named_table, :set, :private])

    {:ok, %{log_limit: log_limit, ets_table_name: ets_table_name}}
  end

  def valid_item?({:error, _err}), do: false
  def valid_item?(%{name: nil}), do: false
  def valid_item?(_), do: true
end
