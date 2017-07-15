defmodule LinkCacheTest do
  use ExUnit.Case

  test "caches and finds the correct data" do
    item = %{id: 1, item_name: "Thunderfury, Blessed Blade of the Windseeker"}
    assert ItemCache.Cache.fetch("A", fn ->
      item
    end) == item

    assert ItemCache.Cache.fetch("A", fn -> "" end) == item
  end
end
