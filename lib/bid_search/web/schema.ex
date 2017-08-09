defmodule BidSearch.Web.Schema do
  @moduledoc """
  Access points for the graphql API 
  """
  use Absinthe.Schema
  import_types BidSearch.Web.Schema.Types
  alias BidSearch.Web.Resolver

  query do
    field :all_items, type: :items_list do
      resolve &BidSearch.Web.Resolver.Item.all/2
    end

    field :item, type: :item do
      arg :id, non_null(:string)

      resolve &Resolver.Item.find_by_id/3
    end

    field :all_auctions, type: :auction_list do
      resolve &Resolver.Auction.all/2
    end

    field :auction, type: :auction do
      arg :id, non_null(:string)

      resolve &Resolver.Auction.find_by_id/3
    end

    field :user, type: :user do
      resolve &Resolver.User.get/2
    end

    field :session, type: :string do
      arg :username, non_null(:string)
      arg :password, non_null(:string)

      resolve &Resolver.User.get_session/3
    end

  end

  mutation do
    field :create_session, type: :string do
      arg :username, non_null(:string)
      arg :password, non_null(:string)

      resolve &Resolver.User.create_session/3
    end

    field :create_user, type: :user do
      arg :username, non_null(:string)
      arg :password, non_null(:string)
      arg :email,    non_null(:string)

      resolve &Resolver.User.create/3
    end
  end
end
