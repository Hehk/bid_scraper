defmodule BidSearch.Web.Router do
  @moduledoc """
  Router for the api
  """
  use BidSearch.Web, :router

  pipeline :graphql do
    plug CORSPlug
  end

  scope "/" do

    get "/graphiql", Absinthe.Plug.GraphiQL, schema: BidSearch.Web.Schema
    post "/graphiql", Absinthe.Plug.GraphiQL, schema: BidSearch.Web.Schema
    forward "/graphql", Absinthe.Plug, schema: BidSearch.Web.Schema
  end

end
