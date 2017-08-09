defmodule BidSearch.Web.Context do
  @behaviour Plug
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    case build_context(conn) do
      {:ok, context} ->
        IO.inspect context
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
         {:ok, current_user}  <- authorize(token) do
      {:ok, %{current_user: current_user}}
    else
      [] -> {:ok, %{}}
      error -> error
    end
  end

  defp authorize(token) do
    {:ok, "test"}
  end

end
