defmodule Cache.Supervisor do
  @moduledoc """
  Supervises the ItemCache.Cache module
  """
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(Cache.Items, [[name: Cache.Items]]),
      worker(Cache.Auctions, [[name: Cache.Auctions]])
    ]

    supervise(children, strategy: :one_for_one)
  end

end
