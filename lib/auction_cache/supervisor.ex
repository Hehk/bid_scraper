defmodule AuctionCache.Supervisor do
  @moduledoc """
  Supervises the AuctionCache.Cache module
  """
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(AuctionCache.Cache, [[name: AuctionCache.Cache]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end

