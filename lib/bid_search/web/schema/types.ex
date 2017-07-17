defmodule BidSearch.Web.Schema.Types do
  @moduledoc """
  Types used for the graphql server
  """

  use Absinthe.Schema.Notation

  object :item do
    field :id, :string
    field :name, :string
    field :condition, :string
    field :auction_id, :string
  end

  object :items_list do
    field :items, list_of(:item)
    field :count, :integer
    field :is_truncated, :boolean
  end
end
