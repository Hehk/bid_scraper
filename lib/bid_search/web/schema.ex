defmodule BidSearch.Web.Schema do
  @moduledoc """
  Access points for the graphql API 
  """
  use Absinthe.Schema
  import_types BidSearch.Web.Schema.Types
  alias BidSearch.Web.Resolver

  query do
    field :all_items, :items_list do
      resolve &BidSearch.Web.Resolver.Item.all/2
    end

    field :item, :item do
      arg :id, non_null(:string)

      resolve &Resolver.Item.find_by_id/3
    end
  end

  mutation do
    field :create_item, :item do
      arg :name, non_null(:string)

      resolve &BidSearch.Web.Resolver.Item.create/3
    end
  end
end
