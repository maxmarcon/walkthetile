defmodule Wtt.Board do
  @moduledoc false

  @board_size Application.get_env(:wtt, :board_size)
  @wall_prob Application.get_env(:wtt, :wall_prob)

  @type tile :: {integer(), integer()}

  @spec generate_walls() :: [tile()]
  def generate_walls() do
    Enum.reduce(1..@board_size, [], fn x, walls ->
      Enum.reduce(1..@board_size, walls, fn y, walls ->
        if :rand.uniform() < @wall_prob do
          [{x, y} | walls]
        else
          walls
        end
      end)
    end)
  end

  @spec random_tile([tile()]) :: tile()
  def random_tile(walls) do
    1..@board_size
    |> Stream.flat_map(fn x ->
      1..@board_size |> Stream.map(&{x, &1})
    end)
    |> Stream.reject(&(&1 in walls))
    |> Enum.random()
  end
end
