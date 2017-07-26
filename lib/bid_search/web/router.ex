defmodule BidSearch.Web.Router do
  @moduledoc """
  Router for the api

  - needs to have pipeline built
  - need to add / resource
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


  # temporary until I work through the best pipeline
  #forward "/graphiql", Absinthe.Plug.GraphiQL, schema: BidSearch.Web.Schema
end
