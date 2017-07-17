defmodule BidSearch.Web.Resolver.Item do
  @moduledoc """
  resolves items from the cache
  """

  def all(_args, _info) do
    items = ItemCache.Cache.all()
    |> Enum.map(fn (item) -> formatItem(item) end)
    limited_items = Enum.take(items, 100)

    {:ok, %{
      items: limited_items,
      count: length(limited_items),
      is_truncated: length(limited_items) < length(items)
    }}
  end

  def find_by_id(_parent, %{id: id}, _info) do
    case ItemCache.Cache.get(id) do
      nil -> {:error, "Item:#{id} not found in store"}
      item -> {:ok, formatItem(item)}
    end
  end

  def create(_parent, attr, _info) do
    new_id = UUID.uuid1()

    with {id, params} <- ItemCache.Cache.insert(new_id, %{
      name: attr.name,
      status: "Good"
    }), do: {:ok, formatItem(id, params)}
  end

  defp formatItem({id, params}), do: formatItem(id, params)
  defp formatItem(id, params) do
    Map.merge(%{id: id}, params)
  end
end
