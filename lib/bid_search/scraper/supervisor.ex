defmodule BidSearch.Scraper.Supervisor do
  @moduledoc """
  Supervisor for the Scraper process
  """
  use Supervisor
  
  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(BidSearch.Scraper.Server, [[name: BidSearch.Scraper.Server]])
    ]

    supervise(children, strategy: :one_for_one)
  end

end
