defmodule Scraper.Component.AuctionDetails do
  import Scraper.Helpers
  @website "https://bid.bidfta.com/cgi-bin/mndetails.cgi?"

  def get(auction_id) do
    case http_get(@website <> auction_id) do
      {:ok, %{body: body}} -> body
      |> harvest_body(auction_id)

      {:error, reason} -> %Scraper.Error{
        context: %{auction_id: auction_id},
        component: :auction_details,
        reason: reason
      }
    end
  end

  defp harvest_body(body, auction_id) do
    auction_table = body
    |> Floki.find("tr[valign=\"top\"]")
    |> Enum.map(fn ({_tag, _attr, children}) -> children end)

    name = body
    |> Floki.find("#auction_title")
    |> Floki.text

    with [date_elem, loc_elem | _rest]   <- auction_table,
         [_title, {_tag, _attr, [date]}] <- date_elem,
         [_title, {_tag, _attr, [loc]}]  <- loc_elem,
         [_pref_num, formatted_name]     <- String.split(name, "-") do
      %{
        id: auction_id,
        date: date,
        location: loc,
        name: String.trim(formatted_name)
      }
    else
      err -> %Scraper.Error{
        context: %{auction_id: auction_id},
        component: :auction_details,
        reason: err
      }
    end
  end
end
