defmodule Scraper.Supervisor do
  @moduledoc """
  Supervisor for the Scraper process
  """
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(Scraper.Server, [[name: Scraper.Server]])
    ]

    #schedule_scrape()
    supervise(children, strategy: :one_for_one)
  end
end
