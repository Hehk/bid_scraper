defmodule ItemCacheTest do
  import ItemCache.Cache
  use ExUnit.Case

  test "insert converts map to tuple" do
    item = %{id: 1, item: "Thunderfury, Blessed Blade of the Windseeker"}
    assert insert(item) == {item.id, %{item: item.item}}
  end

  test "inserts errors on duplicate" do
    item = %{id: 2, item: "Duplicate item!!!"}

    insert(item)
    {err, _msg} = insert(item)
    assert err == :error
  end

  test "all returns all items" do
    insert(2, "test")
    insert(3, "test")

    item_list = all()
    assert is_list(item_list)
    assert length(item_list) >= 2
  end

end
