defmodule BidSearch.Resolver.ItemTest do
  alias BidSearch.AbsintheHelpers
  use BidSearch.Web.ConnCase
  use ExUnit.Case

  @item_1 %{id: "resolver_1", name: "resolver_1", condition: "resolver_1", auction_id: "resolver_1"}
  @item_2 %{id: "resolver_2", name: "resolver_2", condition: "resolver_2", auction_id: "resolver_2"}
  @item_3 %{id: "resolver_3", name: "resolver_3", condition: "resolver_3", auction_id: "resolver_3"}


  describe "Item Resolver" do
    Cache.Items.insert(@item_1)
    Cache.Items.insert(@item_2)
    Cache.Items.insert(@item_3)

    test "all/3 returns all the items", context do
      query = """
      { 
        allItems {
          count
          isTruncated
        }
      }
      """

      res = context.conn
      |> post("/graphql", AbsintheHelpers.query_skeleton(query, ""))
      |> json_response(200)

      %{"data" => data} = res

      assert data == %{
        "allItems" => %{
          "count" => 3,
          "isTruncated" => false,
        }
      }
    end

    test "get/3 returns item by id", context do
      query = """
      {
        item(id: "#{@item_1.id}") {
          name
        }
      }
      """

      res = context.conn
      |> post("/graphql", AbsintheHelpers.query_skeleton(query, ""))
      |> json_response(200)
      %{"data" => data} = res

      assert data == %{
        "item" => %{
          "name" => @item_1.id
        }
      }
    end
  end
end
