defmodule WttWeb.PlayerControllerTest do
  use WttWeb.ConnCase

  @player_name "MickeyMouse"

  test "can create player with random name", %{conn: conn} do
    conn = post(conn, Routes.player_path(conn, :create))

    assert String.length(json_response(conn, 200)["player"]) > 0
  end

  test "can create player with given name", %{conn: conn} do
    conn = post(conn, Routes.player_path(conn, :create, @player_name))

    assert json_response(conn, 200)["player"] == @player_name
  end

  describe "after a player has been created" do
    setup %{conn: conn} do
      post(conn, Routes.player_path(conn, :create, @player_name))

      :ok
    end

    for dir <- [:up, :down, :left, :right] do
      @dir dir
      test "player can be moved #{dir}", %{conn: conn} do
        conn = put(conn, Routes.player_path(conn, :move, @player_name, @dir))

        assert response(conn, 204)
      end
    end

    test "player can attack", %{conn: conn} do
      conn = put(conn, Routes.player_path(conn, :attack, @player_name))

      assert response(conn, 204)
    end

    test "player can't move in an invalid direction", %{conn: conn} do
      conn = put(conn, Routes.player_path(conn, :move, @player_name, :up_and_then_left))

      assert response(conn, 400)
    end
  end

  test "can't move a nonexistent player", %{conn: conn} do
    assert_error_sent 500, fn ->
      put(conn, Routes.player_path(conn, :move, "no_player", :up))
    end
  end

  test "can't attack with a nonexistent player", %{conn: conn} do
    assert_error_sent 500, fn ->
      put(conn, Routes.player_path(conn, :attack, "no_player"))
    end
  end
end
