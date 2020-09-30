defmodule WttWeb.BoardControllerTest do
  use WttWeb.ConnCase

  alias Wtt.TestUtils

  setup do
    on_exit(&TestUtils.terminate_all_players/0)
  end

  setup %{conn: conn} do
    post(conn, Routes.player_path(conn, :create))
    post(conn, Routes.player_path(conn, :create))
    post(conn, Routes.player_path(conn, :create))
    post(conn, Routes.player_path(conn, :create))

    :ok
  end

  test "can retrieve the board status", %{conn: conn} do
    conn = get(conn, Routes.board_path(conn, :get))

    board = json_response(conn, 200)

    assert is_list(board)

    assert Enum.all?(board, fn element ->
             assert %{"tile" => [_, _], "players" => players, "wall" => wall} = element
             assert is_boolean(wall)
             assert is_list(players)

             assert Enum.all?(players, fn player ->
                      assert %{"name" => _, "status" => _} = player
                    end)
           end)

    assert Enum.reduce(board, 0, fn %{"players" => players}, count ->
             count + length(players)
           end) == 4
  end
end
