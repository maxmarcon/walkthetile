defmodule WttWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use WttWeb, :controller

  def call(conn, {:error, reason_atom}) when is_atom(reason_atom) do
    code =
      try do
        Plug.Conn.Status.code(reason_atom)
      rescue
        FunctionClauseError -> :internal_server_error
      end

    conn
    |> put_status(reason_atom)
    |> put_view(WttWeb.ErrorView)
    |> render("#{code}.json", %{
      reason: %{message: Plug.Conn.Status.reason_phrase(code)}
    })
  end

  def call(conn, :ok) do
    send_resp(conn, :no_content, "")
  end
end
