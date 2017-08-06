defmodule Scraper.Component.Items do
  import Scraper.Helpers
  @website "https://bid.bidfta.com/cgi-bin/mnprint.cgi?"

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

  def harvest_body(body, auction_id) do
    body
    |> Floki.find("tr[valign=\"top\"]")
    |> Enum.map(fn ({_tag, _attr, children}) -> children end)
    |> Enum.map(&harvest_item(&1, auction_id))
  end

  def harvest_item([id_elem, {_tag, _attr, details_elem}], auction_id) do
    id = id_elem
    |> Floki.text
    |> String.trim(".")

    details = details_elem
    |> harvest_details
    |> format_details

    Map.merge(details, %{id: id, auction_id: auction_id})
  end

  def harvest_details(details_elem), do: harvest_details(details_elem, %{})
  def harvest_details([{_tag, _attr, [key]}, value, _br | rhs], item)
  when is_bitstring(key) and is_bitstring(value) do
    formatted_value = value
    |> String.trim(":")

    harvest_details(rhs, Map.put(item, key, formatted_value))
  end
  def harvest_details(_, item), do: item

  def format_details(details) do
    {_, details} = Map.pop(details, "Front Page")
    {condition, details} = Map.pop(details, "Additional Info")
    {name, details} = Map.pop(details, "Item Description")

    details
    |> Map.put(:condition, condition)
    |> Map.put(:name, name)
  end
end
