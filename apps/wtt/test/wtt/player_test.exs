defmodule Wtt.PlayerTest do
  @moduledoc false
  alias Wtt.Player

  @player1 "player_1"
  @player2 "player_2"
  @registry Wtt.Registry.Board
  @board_size Application.get_env(:wtt, :board_size)

  use ExUnit.Case, async: true

  test "start_link/2" do
    assert {:ok, _} = Player.start_link(@player1)
  end

  describe "after player has started" do
    setup do
      {:ok, pid} = Player.start_link(@player1)

      [player_pid: pid]
    end

    test "is registered on a tile", %{player_pid: pid} do
      [{{x, y}, ^pid, []}] =
        Registry.select(@registry, [{{:"$1", :"$2", :"$3"}, [], [{{:"$1", :"$2", :"$3"}}]}])

      assert x >= 1 && x <= @board_size
      assert y >= 1 && y <= @board_size
    end

    test "is alive and has the correct name", %{player_pid: pid} do
      assert {@player1, :alive} == GenServer.call(pid, :get_state)
    end
  end
end
