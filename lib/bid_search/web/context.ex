defmodule BidSearch.Web.Context do
  @behaviour Plug
  import Plug.Conn
  alias Cache.Users

  def init(opts), do: opts

  def call(conn, _) do
    case build_context(conn) do
      {:ok, context} ->
        Absinthe.run(conn, MyApp.Schema, context: context)
        put_private(conn, :absinthe, %{context: context})

      {:error, reason} -> conn
        |> send_resp(403, reason)
        |> halt

      _ -> conn
        |> send_resp(400, "bad_request")
        |> halt
    end
  end

  def build_context(conn) do
    auth_header = get_req_header(conn, "auth")
    with ["Bearer " <> token] <- auth_header,
         current_user         <- Users.find_by_session(token) do
      {:ok, %{current_user: current_user}}
    else
      _ -> if auth_header != [] do
        {:ok, nil}
      else
        {:error, "auth header was not provided on request"}
      end
    end
  end

  defp authorize(token) do
    {:ok, Users.find_by_session(token)}
  end

end
