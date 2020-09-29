defmodule Wtt.Game do
  @player_supervisor Wtt.PlayerSupervisor
  @registry Wtt.Registry.Board

  alias Wtt.Player

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

  def retrieve_board_status() do
  end
end
