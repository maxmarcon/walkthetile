defmodule WttWeb.PageControllerTest do
  use WttWeb.ConnCase

  test "GET /game returns the game page", %{conn: conn} do
    conn = get(conn, "/game")
    assert html_response(conn, 200) =~ "Walk the tile!"
  end

  test "GET /other_url redirects to the game page", %{conn: conn} do
    conn = get(conn, "/other_url")
    assert redirected_to(conn, 301) == "/game"
  end
end
