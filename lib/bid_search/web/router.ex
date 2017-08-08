defmodule BidSearch.Web.Router do
  @moduledoc """
  Router for the api
  """
  use BidSearch.Web, :router

  pipeline :graphql do
    plug CORSPlug
    plug BidSearch.Web.Context
  end

  scope "/" do
    pipe_through :graphql

    forward "/graphql", Absinthe.Plug, schema: BidSearch.Web.Schema
  end

  forward "/graphiql", Absinthe.Plug.GraphiQL, schema: BidSearch.Web.Schema
end
