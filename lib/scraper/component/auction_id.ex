defmodule Scraper.Component.AuctionId do
  import Scraper.Helpers
  @website "http://www.bidfta.com/"

  def get() do
    case http_get(@website) do
      {:ok, %{body: body}} -> body |> harvest_body
      _                    -> []
    end
  end

  def harvest_body(body) do
    body
    |> Floki.find(".auction > a")
    |> Enum.map(&harvest_id(&1))
  end

  def harvest_id(auction_elem) do
    with {_, attr, _}         <- auction_elem,
         [{"href", link} | _] <- attr,
         [_prefix, id]        <- String.split(link, "?") do
      id
    else
      err -> err
      %Scraper.Error{
        context: %{},
        component: :auction_id,
        reason: err
      }
    end
  end
end
