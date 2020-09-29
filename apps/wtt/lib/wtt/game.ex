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
    |> Enum.concat(Enum.map(walls, &%{tile: &1, wall: true}))
    |> Enum.group_by(fn %{tile: tile} -> tile end, &Map.delete(&1, :tile))
    |> Enum.map(fn {tile, entries} -> {tile, reduce_board_elements(entries)} end)
    |> Enum.map(fn {tile, %{players: players, wall: wall}} ->
      %{tile: tile, players: players, wall: wall}
    end)
  end

  defp reduce_board_elements(entries) do
    Enum.reduce(entries, %{players: [], wall: false}, fn
      %{player: player}, acc ->
        Map.update!(acc, :players, &[player | &1])

      %{wall: wall}, acc ->
        Map.update!(acc, :wall, &(&1 || wall))
    end)
  end
end
