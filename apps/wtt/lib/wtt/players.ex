defmodule Wtt.Players do
  @player_supervisor Wtt.PlayerSupervisor
  @registry Wtt.Registry.Board

  alias Wtt.Player

  def ensure_player_started(name) do
    case DynamicSupervisor.start_child(@player_supervisor, {Player, name}) do
      {:ok, _} -> :ok
      {:error, {:already_started, _}} -> :ok
      error -> error
    end
  end

  def retrieve_board_status() do
  end
end
