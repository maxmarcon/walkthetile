defmodule Wtt.Board do
  @moduledoc false

  @board_size Application.get_env(:wtt, :board_size)
  @wall_prob Application.get_env(:wtt, :wall_prob)

  def generate_walls() do
    Enum.reduce(1..@board_size, [], fn x, walls ->
      Enum.reduce(1..@board_size, walls, fn y, walls ->
        if :random.uniform() < @wall_prob do
          [{x, y} | walls]
        else
          walls
        end
      end)
    end)
  end
end
