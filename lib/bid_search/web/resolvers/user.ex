defmodule BidSearch.Web.Resolver.User do
  @moduledoc """
  Resolves Users for graphql queries
  """
  alias Cache.Users

  @desc """
  Get user by token
  """
  def get(_args, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end
  def get(_args, _context), do: {:ok, nil}

  @desc """
  Create a new user and return it
  """
  def create(user = %{username: _username, password: _password, email: _email}, _info) do
    case Users.insert(user) do
      true -> {:ok, user}
      res  -> res
    end
  end

  @desc """
  Gets a session token for a user currently missing one
  """
  def login(%{username: username, password: password}, _info) do
    user = Users.get(username)
    case user.password == password do
      true -> {:ok, user}
      false -> {:error, "Invalid username or password"}
    end
  end

end
