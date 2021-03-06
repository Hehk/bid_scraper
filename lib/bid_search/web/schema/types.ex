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

  object :auction do
    field :id, :string
    field :name, :string
    field :location, :string
  end

  object :auction_list do
    field :auctions, list_of(:auction)
    field :count, :integer
  end

  object :user do
    field :email, :string
    field :username, :string
    field :session, :string
  end
end
