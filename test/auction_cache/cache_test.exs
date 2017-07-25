defmodule AuctionCacheTest do
  import AuctionCache.Cache 
  use ExUnit.Case

  test "inserting within the cache" do
    auction = %{id: 1, name: "testing123"}
    assert insert(auction) == true
  end

  test "inserting duplicate causes error" do
    auction = %{id: 2, name: "inserting error"}

    insert(auction)
    {err, _msg} = insert(auction)
    assert err == :error
  end

  test "getting within the cache" do
    id = 3
    auction = %{id: id, name: "getting"}

    insert(auction)
    assert get(id) == auction
  end

  test "all within the cache" do
    set(%{id: 4, name: "testing"})
    set(%{id: 5, name: "testing"})

    assert length(all()) >= 2
  end

  test "convert tuple form to map" do
    lhs = {1, %{test: "test"}}
    rhs = %{id: 1, test: "test"}

    assert create_map_auction(lhs) == rhs
  end
  test "convert map form to tuple" do
    lhs = %{id: 1, test: "test"}
    rhs = {1, %{test: "test"}}

    assert create_tuple_auction(lhs) == rhs
  end

end
