defmodule WttWeb.PageController do
  use WttWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def redirect_to_game(conn, _params) do
    conn
    |> put_status(301)
    |> redirect(to: "/game")
  end
end
