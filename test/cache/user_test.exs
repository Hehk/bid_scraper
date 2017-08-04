defmodule CacheUserTest do
  import Cache.Users
  use ExUnit.Case

  @user_1 %{username: "test_1", password: "", email: ""}

  test "insert/1 user in cache" do
    assert insert(@user_1) == true
  end

  test "insert/1 :ok on different username but same content" do
    user = %{username: "test_2", password: "", email: ""}
    insert(user)
    res = insert(%{user | username: "test_2_dif"})

    assert res == true
  end

  test "insert/1 :error on duplicate username" do
    user = %{username: "test_3", password: "", email: ""} 
    insert(user)
    {err, _msg} = insert(user)

    assert err == :error
  end

  test "valid/2 -> true if username and password match" do
    user = %{username: "valid_1", password: ""}
    insert(user)

    assert valid(user.username, user.password) == true
  end

  test "valid/2 -> false if username or password dont match" do
    user = %{username: "valid_2", password: "valid"}
    insert(user)

    assert valid(user.username, "invalid") == false
  end

  test "valid/2 -> false if user does not exist" do
    assert valid("invalid", "invalid") == false
  end

end
