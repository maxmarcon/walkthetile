defmodule WttWeb.PageControllerTest do
  use WttWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Walk the tile!"
  end
end
