defmodule CacheUserTest do
  import Cache.Users
  use ExUnit.Case

  test "insert/1 user in cache" do
    user = %{username: "test_1", password: "", email: ""}
    assert insert(user) == true
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

  test "convert_to_user_map/1 converts tuple to map" do
    user = {"me", %{password: "test", email: "test"}}
    assert convert_to_user_map(user) == %{
      username: "me",
      password: "test",
      email: "test"
    }
  end

  test "convert_to_user_tuple/1 converts map to tuple" do
    user = %{username: "me", password: "test", email: "test"}
    assert convert_to_user_tuple(user) == {
      "me",
      %{password: "test", email: "test"}
    }
  end

end
