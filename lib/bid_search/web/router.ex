defmodule BidSearch.Web.Router do
  @moduledoc """
  Router for the api

  - needs to have pipeline built
  - need to add / resource
  """
  use BidSearch.Web, :router

  # temporary until I work through the best pipeline
  forward "/graphql", Absinthe.Plug, schema: BidSearch.Web.Schema
  forward "/graphiql", Absinthe.Plug.GraphiQL, schema: BidSearch.Web.Schema
end
