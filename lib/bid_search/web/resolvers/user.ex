defmodule BidSearch.Web.Resolver.User do
  @moduledoc """
  Resolves Users for graphql queries
  """

  def get(_args, %{context: context}) do
    IO.inspect context
    {:ok, %{
      username: "test",
      email: "test"
    }}
  end
  def get(_args, _context), do: {:ok, nil}

  def create(_parent, %{username: username, password: password, email: email}, _info) do
    {:ok, %{
      username: username,
      email: email
    }}
  end

  def get_session(_parent, %{username: username, password: password}, _info) do
    {:ok, username}
  end

  def create_session(_parent, %{username: username, password: password}, _info) do
    {:ok, %{
      username: username,
      email: username
    }}
  end

end
