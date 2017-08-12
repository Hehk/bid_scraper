defmodule BidSearch.Resolver.AuctionTest do
  alias BidSearch.AbsintheHelpers
  use BidSearch.Web.ConnCase
  use ExUnit.Case

  @auction_1 %{id: "t1", location: "t1", date: "t1", name: "t1"}
  @auction_2 %{id: "t2", location: "t2", date: "t2", name: "t2"}
  @auction_3 %{id: "t3", location: "t3", date: "t3", name: "t3"}

  describe "Auction Resolver" do
    Cache.Auctions.insert(@auction_1)
    Cache.Auctions.insert(@auction_2)
    Cache.Auctions.insert(@auction_3)

    test "all/2 returns all_auctions map", context do
      query = """
      {
        allAuctions {
          count
        }
      }
      """

      %{data: data} = context.conn
      |> put_req_header("auth", "test")
      |> post("/graphql", AbsintheHelpers.query_skeleton(query, ""))
      |> json_response(200)
      |> AbsintheHelpers.res_to_atoms

      assert data == %{
        allAuctions: %{
          count: 3
        }
      }
    end

    test "get/3 returns item by id", context do
      query = """
      {
        auction(id: "#{@auction_1.id}") {
          name
        }
      }
      """

      %{data: data} = context.conn
      |> put_req_header("auth", "test")
      |> post("/graphql", AbsintheHelpers.query_skeleton(query, ""))
      |> json_response(200)
      |> AbsintheHelpers.res_to_atoms

      assert data == %{
        auction: %{
          name: @auction_1.name
        }
      }
    end
  end

end
