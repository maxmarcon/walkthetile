defmodule Wtt.GameTest do
  @moduledoc false
  alias Wtt.Game

  @player1 "player_1"
  @supervisor Wtt.PlayerSupervisor

  use ExUnit.Case

  describe "ensure_player_started/1" do
    test "starts a new player with a given name under the player supervisor" do
      assert {:ok, @player1} = Game.ensure_player_started(@player1)
      [{_, pid, _, _}] = DynamicSupervisor.which_children(@supervisor)

      assert %{name: @player1, status: :alive} = :sys.get_state(pid)

      :ok = DynamicSupervisor.terminate_child(@supervisor, pid)
    end

    test "starts a new player with a randomly generated name under the player supervisor" do
      assert {:ok, player_name} = Game.ensure_player_started()
      [{_, pid, _, _}] = DynamicSupervisor.which_children(@supervisor)

      assert %{name: ^player_name, status: :alive} = :sys.get_state(pid)

      :ok = DynamicSupervisor.terminate_child(@supervisor, pid)
    end

    test "doesn't start a second player with the same name" do
      assert {:ok, @player1} = Game.ensure_player_started(@player1)
      assert {:ok, @player1} = Game.ensure_player_started(@player1)
      [{_, pid, _, _}] = DynamicSupervisor.which_children(@supervisor)

      assert %{name: @player1, status: :alive} = :sys.get_state(pid)

      :ok = DynamicSupervisor.terminate_child(@supervisor, pid)
    end
  end
end
