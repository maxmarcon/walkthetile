defmodule WttWeb.BoardView do
  use WttWeb, :view

  def render("board.json", %{board: board}) do
    board
    |> Enum.map(fn board_elem = %{tile: tile} ->
      %{board_elem | tile: Tuple.to_list(tile)}
    end)
  end
end
