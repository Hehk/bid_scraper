defmodule BidSearch.Application do
  @moduledoc """
  Entrypoint for the application
  """
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(BidSearch.Web.Endpoint, []),
      # Start your own worker by calling: BidSearch.Worker.start_link(arg1, arg2, arg3)
      # worker(BidSearch.Worker, [arg1, arg2, arg3]),
      supervisor(ItemCache.Supervisor, [])
    ]

    BidSearch.Scraper.init()

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BidSearch.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
