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
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         current_user         <- Users.find_by_session(token) do
      {:ok, %{current_user: current_user}}
    end
  end

  defp authorize(token) do
    {:ok, }
  end

end
