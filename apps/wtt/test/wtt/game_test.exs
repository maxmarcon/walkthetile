defmodule Wtt.GameTest do
  @moduledoc false
  alias Wtt.Game

  @player1 "player_1"
  @supervisor Wtt.PlayerSupervisor
  @registry Wtt.Registry.Board
  @walls [{3, 4}, {5, 9}, {4, 5}]
  @nof_players 10

  use ExUnit.Case

  defp terminate_all_players do
    for {_, pid, _, _} <- DynamicSupervisor.which_children(@supervisor) do
      :ok = DynamicSupervisor.terminate_child(@supervisor, pid)
    end
  end

  setup do
    on_exit(&terminate_all_players/0)
  end

  describe "ensure_player_started/1" do
    test "starts a new player with a given name under the player supervisor" do
      assert {:ok, @player1} = Game.ensure_player_started(@player1)
      [{_, pid, _, _}] = DynamicSupervisor.which_children(@supervisor)

      assert %{name: @player1, status: :alive} = :sys.get_state(pid)
    end

    test "doesn't start a second player with the same name" do
      assert {:ok, @player1} = Game.ensure_player_started(@player1)
      assert {:ok, @player1} = Game.ensure_player_started(@player1)
      [{_, pid, _, _}] = DynamicSupervisor.which_children(@supervisor)

      assert %{name: @player1, status: :alive} = :sys.get_state(pid)
    end
  end

  describe "ensure_player_started/0" do
    test "starts a new player with a randomly generated name under the player supervisor" do
      assert {:ok, player_name} = Game.ensure_player_started()
      [{_, pid, _, _}] = DynamicSupervisor.which_children(@supervisor)

      assert %{name: ^player_name, status: :alive} = :sys.get_state(pid)
    end
  end

  describe "retrieve_board_status/0" do
    setup do
      :ok = Registry.put_meta(@registry, :walls, @walls)

      players =
        for _ <- 1..@nof_players do
          {:ok, player_name} = Game.ensure_player_started()
          player_name
        end

      [players: players]
    end

    test "returns the entire status of the playing board" do
      board = Game.retrieve_board_status()
      assert is_list(board)

      %{walls: walls, players: players, pos: pos} =
        for tile <- board, reduce: %{players: [], walls: 0, pos: []} do
          acc ->
            assert %{pos: {x, y} = pos, players: players, wall: wall} = tile
            assert is_list(players)
            assert is_boolean(wall)
            assert is_integer(x)
            assert is_integer(y)
            assert !wall || Enum.empty?(players)

            acc
            |> Map.update!(:pos, &[pos | &1])
            |> Map.update!(:players, &(players ++ &1))
            |> Map.update!(
              :walls,
              &(&1 +
                  if wall do
                    1
                  else
                    0
                  end)
            )
        end

      assert length(Enum.uniq(pos)) == length(pos)
      assert walls == 3
      assert length(players) == @nof_players

      for player <- players do
        assert %{name: name, status: status} = player
        assert is_binary(name)
        assert String.length(name) > 0
        assert status == :alive
      end

      assert length(Enum.uniq_by(players, & &1.name)) == length(players)
    end
  end
end
