defmodule Wtt.PlayerTest do
  @moduledoc false
  alias Wtt.Player

  @player1 "player_1"
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

    test "is registered on a random tile with correct name and status", %{player_pid: pid} do
      [{{x, y}, ^pid, %{name: @player1, status: :alive}}] =
        Registry.select(
          @registry,
          [
            {
              {:"$1", :"$2", :"$3"},
              [{:==, :"$3", %{name: @player1, status: :alive}}],
              [{{:"$1", :"$2", :"$3"}}]
            }
          ]
        )

      assert x >= 1 && x <= @board_size
      assert y >= 1 && y <= @board_size
    end

    test "is registered by name", %{player_pid: pid} do
      assert [{pid, []}] == Registry.lookup(@registry, @player1)
    end
  end

  describe "a player located in the center of the board" do
    setup do
      {:ok, pid} = Player.start_link(@player1, fn -> {5, 5} end)

      [player_pid: pid]
    end

    values = [
      [:up, {5, 5}, {5, 6}],
      [:down, {5, 5}, {5, 4}],
      [:left, {5, 5}, {4, 5}],
      [:right, {5, 5}, {6, 5}]
    ]

    for [dir, initial_pos, expected_pos] <- values do
      @dir dir
      @initial_pos initial_pos
      @expected_pos expected_pos
      test "can move #{dir}", %{player_pid: pid} do
        :ok = GenServer.call(pid, @dir)

        assert [] = Registry.lookup(@registry, @initial_pos)

        assert [{pid, %{name: @player1, status: :alive}}] =
                 Registry.lookup(@registry, @expected_pos)
      end
    end
  end

  describe "a player located on the edge of the board" do
    values = [
      ["upper", {5, 10}, :up],
      ["lower", {5, 1}, :down],
      ["leftmost", {1, 5}, :left],
      ["rightmost", {10, 5}, :right]
    ]

    for [desc, initial_pos, dir] <- values do
      @dir dir
      @initial_pos initial_pos
      test "can't move #{dir} from the #{desc} edge" do
        {:ok, pid} = Player.start_link(@player1, fn -> @initial_pos end)

        :ok = GenServer.call(pid, @dir)

        assert [{pid, %{name: @player1, status: :alive}}] =
                 Registry.lookup(@registry, @initial_pos)
      end
    end
  end
end
