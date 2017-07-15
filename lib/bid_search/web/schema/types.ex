defmodule BidSearch.Web.Schema.Types do
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
