defmodule Cache.Users do
  @moduledoc """
  Provides the caching system for users
  """
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [
      {:ets_table_name, :user_cache_table},
      {:log_limit, 1_000_000}
    ], opts)
  end

  def init(args) do
    [{:ets_table_name, ets_table_name}, {:log_limit, log_limit}] = args
    :ets.new(ets_table_name, [:named_table, :set, :private])

    {:ok, %{log_limit: log_limit, ets_table_name: ets_table_name}}
  end

  # ------------------------------------------------------------------------
  # CLIENT SIDE
  # ------------------------------------------------------------------------

  def insert(user) do
    case get(user.username) do
      nil -> set(user)
      _   -> {:error, "User:#{user.username} already found within store"}
    end
  end
  def get(username), do: GenServer.call(__MODULE__, {:get, username})
  def set(user),     do: GenServer.call(__MODULE__, {:set, user})
  def valid(username, password) do
    case get(username) do
      nil  -> false
      user -> user.password == password
    end
  end

  # ------------------------------------------------------------------------
  # SERVER SIDE
  # ------------------------------------------------------------------------

  def handle_call({:get, username}, _from, state) do
    %{ets_table_name: ets_table_name} = state
    user = case :ets.lookup(ets_table_name, username) do
      []    -> nil
      [res] -> res |> create_user_map
    end

    {:reply, user, state}
  end

  def handle_call({:set, user}, _from, state) do
    %{ets_table_name: ets_table_name} = state
    formatted_user = user
    |> create_user_tuple
    true = :ets.insert(ets_table_name, formatted_user)

    {:reply, true, state}
  end

  # ------------------------------------------------------------------------
  # HELPER FUNCTIONS
  # ------------------------------------------------------------------------

  def create_user_map({username, user_details}), do: Map.put(user_details, :username, username)
  def create_user_tuple(user),                   do: Map.pop(user, :username)
  def clean_output(user) do
    {_pwd, clean_user} = Map.pop(user, :password)
    clean_user
  end

  # TODO: add function to clean input, like encrypting passwords

end
