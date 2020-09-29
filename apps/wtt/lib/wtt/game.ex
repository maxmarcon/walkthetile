defmodule Wtt.Game do
  @player_supervisor Wtt.PlayerSupervisor
  @registry Wtt.Registry.Board

  alias Wtt.Player

  @type player_status() :: %{name: binary(), status: :alive | :dead}

  @type board_elem() :: %{
          tile: Board.tile(),
          players: [player_status()],
          wall: boolean()
        }

  @spec ensure_player_started(binary()) :: {:ok, binary()} | term()
  def ensure_player_started(name) do
    case DynamicSupervisor.start_child(@player_supervisor, {Player, name}) do
      {:ok, _} -> {:ok, name}
      {:error, {:already_started, _}} -> {:ok, name}
      error -> error
    end
  end

  @spec ensure_player_started() :: {:ok, binary()}
  def ensure_player_started(), do: ensure_player_started(Faker.Superhero.name())

  @spec retrieve_board_status() :: [board_elem()]
  def retrieve_board_status() do
    {:ok, walls} = Registry.meta(@registry, :walls)

    Registry.select(@registry, [{{:"$1", :_, :"$3"}, [], [%{tile: :"$1", player: :"$3"}]}])
    |> Enum.reduce(%{}, fn %{tile: tile, player: player}, acc ->
      Map.update(acc, tile, [player], &[player | &1])
    end)
    |> Enum.map(fn {tile, players} -> %{tile: tile, players: players, wall: false} end)
    |> Enum.concat(Enum.map(walls, &%{tile: &1, players: [], wall: true}))
  end
end
