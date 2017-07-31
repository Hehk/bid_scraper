defmodule BidSearch.Web.Resolver.Auction do
  @moduledoc """
  Auction resolver
  """
  alias Cache.Auctions

  def all(_args, _info) do
    auctions = Auctions.all()

    {:ok, %{
      auctions: auctions,
      count: length(auctions)
    }}
  end

  def find_by_id(_parent, %{id: id}, _info) do
    case Auctions.get(id) do
      nil -> {:error, "Auction:#{id} not found in store"}
      auction -> {:ok, auction}
    end
  end
end
