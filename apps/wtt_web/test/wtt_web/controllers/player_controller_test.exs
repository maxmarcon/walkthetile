defmodule WttWeb.PlayerControllerTest do
  use WttWeb.ConnCase

  test "can create player with random name", %{conn: conn} do
    conn = post(conn, Routes.player_path(conn, :create))

    assert String.length(json_response(conn, 200)["player"]) > 0
  end

  test "can create player with given name", %{conn: conn} do
    conn = post(conn, Routes.player_path(conn, :create, "MickeyMouse"))
    
    assert json_response(conn, 200)["player"] == "MickeyMouse"
  end
end
