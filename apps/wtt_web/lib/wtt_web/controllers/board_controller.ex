defmodule WttWeb.BoardController do
  use WttWeb, :controller

  alias Wtt.Game

  def get(conn, _params) do
    render(conn, :board, %{board: Game.retrieve_board_status()})
  end
end
