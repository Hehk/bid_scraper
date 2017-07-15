defmodule BidSearch.Web.Router do
  use BidSearch.Web, :router

  # temporary until I work through the best pipeline
  forward "/graphql", Absinthe.Plug, schema: BidSearch.Web.Schema
  forward "/graphiql", Absinthe.Plug.GraphiQL, schema: BidSearch.Web.Schema
end
