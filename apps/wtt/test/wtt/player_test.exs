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

    test "is registered on a tile with correct name and status", %{player_pid: pid} do
      [{{x, y}, ^pid, %{name: @player1, status: :alive}}] =
        Registry.select(@registry, [{{:"$1", :"$2", :"$3"}, [{:==, :"$3", %{name: @player1, status: :alive}}], [{{:"$1", :"$2", :"$3"}}]}])

      assert x >= 1 && x <= @board_size
      assert y >= 1 && y <= @board_size
    end

    test "is registered by name", %{player_pid: pid} do
      [{pid, []}] = Registry.lookup(@registry, @player1)
    end
  end
end
