defmodule BidSearch.Web.Resolver.Item do
  @moduledoc """
  resolves items from the cache
  """
  @item_limit 100
  alias Cache.Items

  def all(_args, _info) do
    items = Items.all()

    # limiting the response to so an enourmous object is not sent
    limited_items = items
    |> limit_items
    |> Enum.map(&formatItem(&1))

    {:ok, %{
      items: limited_items,
      count: length(limited_items),
      is_truncated: length(limited_items) < length(items)
    }}
  end

  def find_by_id(_parent, %{id: id}, _info) do
    case Items.get(id) do
      nil -> {:error, "Item:#{id} not found in store"}
      item -> {:ok, formatItem(item)}
    end
  end

  # currently needed to filter out dangerous characters that ruin the poison
  # encoding
  defp filter_string(str), do: filter_string(str, "")
  defp filter_string(<<char>> <> rest, acc) when char < 0x80 do
    filter_string(rest, acc <> <<char>>)
  end
  defp filter_string(<<_char>> <> rest, acc), do: filter_string(rest, acc)
  defp filter_string("", acc), do: acc

  defp formatItem({id, params}), do: formatItem(id, params)
  defp formatItem(id, params) do
    Map.put(params, :id, id)
  end
  defp limit_items(items), do: Enum.take(items, @item_limit)
end
