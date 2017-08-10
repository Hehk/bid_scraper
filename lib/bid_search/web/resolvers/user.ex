defmodule BidSearch.Web.Resolver.User do
  @moduledoc """
  Resolves Users for graphql queries
  """

  @desc """
  Get user by token
  """
  def get(_args, %{context: context}) do
    {:ok, %{
      username: "test",
      email: "test"
    }}
  end
  def get(_args, _context), do: {:ok, nil}

  @desc """
  Create a new user and return it
  """
  def create(%{username: username, password: password, email: email}, _info) do
    {:ok, %{
      username: username,
      email: email
    }}
  end

  @desc """
  Gets a session token for a user currently missing one
  """
  def get_session(%{username: username, password: password}, _info) do
    {:ok, username}
  end

end
