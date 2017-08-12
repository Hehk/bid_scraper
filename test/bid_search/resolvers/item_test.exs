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

    test "all/2 returns all_items map", context do
      query = """
      { 
        allItems {
          count
          isTruncated
        }
      }
      """

      %{data: data} = context.conn
      |> put_req_header("auth", "test")
      |> post("/graphql", AbsintheHelpers.query_skeleton(query, ""))
      |> json_response(200)
      |> AbsintheHelpers.res_to_atoms

      assert data == %{
        allItems: %{
          count: 3,
          isTruncated: false
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

      %{data: data} = context.conn
      |> put_req_header("auth", "test")
      |> post("/graphql", AbsintheHelpers.query_skeleton(query, ""))
      |> json_response(200)
      |>  AbsintheHelpers.res_to_atoms

      assert data == %{
        item: %{
          name: @item_1.id
        }
      }
    end
  end
end
