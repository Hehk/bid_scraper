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

      supervisor(Cache.Supervisor, []),

      supervisor(BidSearch.Scraper.Supervisor, [])
    ]

    # temporary until the genserver works
    # BidSearch.Scraper.init()

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BidSearch.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
