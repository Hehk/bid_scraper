defmodule CacheUserTest do
  import Cache.Users
  use ExUnit.Case

  @user_1 %{username: "test_1", password: "", email: ""}

  test "insert user in cache" do
    assert insert(@user_1) == true
  end

  test "insert :ok on different username but same content" do
    user = %{username: "test_2", password: "", email: ""}
    insert(user)
    res = insert(%{user | username: "test_2_dif"})

    assert res == true
  end

  test "insert :error on duplicate username" do
    user = %{username: "test_2", password: "", email: ""} 
    insert(user)
    {err, _msg} = insert(user)

    assert err == :error
  end

end
