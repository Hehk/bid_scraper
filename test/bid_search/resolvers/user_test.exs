defmodule BidSearch.Resolver.UserTest do
  alias BidSearch.AbsintheHelpers
  use BidSearch.Web.ConnCase
  use ExUnit.Case

  @user_1 %{username: "bob", password: "test", email: "test", session: "test"}
  @user_2 %{username: "frank", password: "test", email: "test", session: "test_2"}
  @user_3 %{username: "le-a", password: "test", email: "test", session: "test_3"}

  describe "User Resolver" do
    Cache.Users.insert(@user_1)
    Cache.Users.insert(@user_2)
    Cache.Users.insert(@user_3)

    test "get/2 returns current user by session", context do
      query = """
      {
        user {
          username
        }
      }
      """

      %{data: data} = context.conn
      |> put_req_header("auth", "Bearer #{@user_1.session}")
      |> post("/graphql", AbsintheHelpers.query_skeleton(query, ""))
      |> json_response(200)
      |> AbsintheHelpers.res_to_atoms

      assert data == %{
        user: %{
          username: @user_1.username
        }
      }
    end
  end
end
