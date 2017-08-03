defmodule BidSearch.Scraper do
  @moduledoc """
  Scraper server for managing scraping bidfta and updating the cache
  """
  @website "http://www.bidfta.com/"
  @auction_details "https://bid.bidfta.com/cgi-bin/mndetails.cgi?"
  @auction_items "https://bid.bidfta.com/cgi-bin/mnprint.cgi?"
  require Logger

  defmodule BidSearch.Scraper.Error do
    defstruct auction_id: nil, type: nil
    @type t :: %__MODULE__{auction_id: String.t, type: reference}
  end

  defp get(url), do: HTTPoison.get(url, [], [ssl: [{:versions, [:'tlsv1.2']}]])

  def get_auction_ids() do
    case get(@website) do
      {:ok, %{body: body}} -> body
        |> Floki.find(".auction > a")
        |> Enum.map(&harvest_id(&1))
        |> Enum.filter(fn id -> id != "" end)

      # occurs due to bug with erlang 1.9
      {:error, %{id: nil, reason: :connect_timeout}} ->
        Logger.error "error in getting auction ids"
        []
    end
  end

  def get_auction_details(auction_id) do
    case get(@auction_details <> auction_id) do
      {:ok, %{body: body}} -> body
        |> Floki.find("tr[valign=\"top\"]")
        |> Enum.map(fn ({_tag, _attr, children}) -> children end)
        |> create_auction(auction_id)

      _ -> 
        Logger.error "details #{auction_id}"
        {:error, %BidSearch.Scraper.Error{auction_id: auction_id, type: :details}}
    end
  end

  def get_items(auction_id) do
    case get("#{@auction_items}#{auction_id}") do
      {:ok, %{body: body}} -> body
        |> Floki.find("tr[valign=\"top\"]")
        |> Enum.map(fn ({_tag, _attr, children}) -> children end)
        |> Enum.map(&(create_item(&1, auction_id)))

      _ -> 
        Logger.error "items #{auction_id}"
        {:error, %BidSearch.Scraper.Error{auction_id: auction_id, type: :items}}
    end
  end

  def create_item([id_elem, details_elem], auction_id) do
    {_tag, _attr, [unformatted_id]} = id_elem
    {_tag, _attr, details_enum} = details_elem

    id = String.slice(unformatted_id, 0, String.length(unformatted_id) - 1)
    details = details_enum 
    |> gather_details()
    |> format_details

    Map.merge(details, %{id: id, auction_id: auction_id})
  end

  defp gather_details(details_enum), do: gather_details(details_enum, %{})
  defp gather_details([{_b, _attr, [key]}, value_elem, _br | rhs], item)
  when is_bitstring(key) and is_bitstring(value_elem) do
    value = value_elem
    |> String.slice(1, String.length(value_elem))
    |> String.trim()

    gather_details(rhs, Map.put(item, key, value))
  end
  defp gather_details(_, item), do: item

  defp format_details(details) do
    {_, details} = Map.pop(details, "Front Page")
    {condition, details} = Map.pop(details, "Additional Info")
    {name, details} = Map.pop(details, "Item Description")

    details
    |> Map.put(:condition, condition)
    |> Map.put(:name, name)
  end

  def create_auction(auction_page, auction_id) do
    with [date_element, loc_element | _rest] <- auction_page,
         [_title, {_elem_type, _attr, [date]}] <- date_element,
         [_title, {_elem_type, _attr, [loc]}] <- loc_element do
      %{
        id: auction_id,
        date: date,
        location: loc
      }
    end
  end

  def harvest_id(page_elem) do
    with {_, attr, _}         <- page_elem,
         [{"href", link} | _] <- attr,
         [_prefix, id]        <- String.split(link, "?") do
      id
    else
      err -> err
      Logger.error "Failed scraping an auction_id"
      ""
    end
  end
end
