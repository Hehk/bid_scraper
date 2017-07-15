defmodule BidSearch.Scraper do
  @website "http://www.bidfta.com/"
  @auction_details "https://bid.bidfta.com/cgi-bin/mndetails.cgi?"
  @auction_items "https://bid.bidfta.com/cgi-bin/mnprint.cgi?"

  def init() do
    spawn fn ->
      IO.inspect("item")
      monitor()
    end
  end

  def monitor(interval \\ 500000) do
    scrape()
    |> Enum.map(&ItemCache.Cache.insert(&1))

    IO.inspect("finished")
    Process.sleep(interval)
    monitor(interval)
  end

  def scrape() do
    get_auctions()
    |> Enum.map(&Task.async(fn ->
      get_items(&1)
    end))
    |> Enum.map(&Task.await(&1, 20000))
    |> List.flatten
    |> Enum.filter(&valid_item?(&1))
  end

  def get_auctions() do
    with {:ok, %{body: body}} <- HTTPoison.get(@website) do
      IO.puts("getting auctions")

      body
      |> Floki.find(".auction > a")
      |> Enum.map(fn ({_, attr, _}) -> attr end)
      |> Enum.map(fn ([{"href", test} | _]) -> test end)
      |> Enum.map(&(String.split(&1, "?")))
      |> Enum.map(fn ([_prefix, id]) -> id end)
    end
  end

  def get_items(auction_id) do
    with {:ok, %{body: body}} <- HTTPoison.get(@auction_items <> auction_id) do

      IO.puts("getting #{auction_id}")

      body
      |> Floki.find("tr[valign=\"top\"]")
      |> Enum.map(fn ({_tag, _attr, children}) -> children end)
      |> Enum.map(&(create_item(&1, auction_id)))
    end
  end

  def valid_item?({:error, _err}), do: false
  def valid_item?(%{name: nil}), do: false
  def valid_item?(_), do: true

  def create_item([id_elem, details_elem], auction_id) do
    {_tag, _attr, [unformatted_id]} = id_elem
    {_tag, _attr, details_enum} = details_elem

    id = String.slice(unformatted_id, 0, String.length(unformatted_id) - 1)
    details = gather_details(details_enum, %{}) |> format_details

    Map.merge(details, %{id: id, auction_id: auction_id})
  end

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
end
