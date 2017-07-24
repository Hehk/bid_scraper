defmodule AuctionCacheTest do
  import AuctionCache.Cache 
  use ExUnit.Case

  test "setting within the cache" do
    auction = %{id: 1, name: "testing123"}
    assert set(auction) == true
  end

  test "getting within the cache" do
    assert get(1) == %{id: 1, name: "testing123"}
  end

  test "all within the cache" do
    set(%{id: 2, name: "testing"})
    set(%{id: 3, name: "testing"})

    assert length all() == 3
  end

end
