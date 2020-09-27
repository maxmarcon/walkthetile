defmodule Wtt.PlayerTest do
  @moduledoc false
  alias Wtt.Player

  @player1 "player_1"
  @registry Wtt.Registry.Board
  @board_size Application.get_env(:wtt, :board_size)

  use ExUnit.Case

  test "start_link/2 can start player" do
    assert {:ok, _} = Player.start_link(@player1)
  end

  describe "after player has been created" do
    setup do
      {:ok, _} = Player.start_link(@player1)

      :ok
    end

    test "start_link/2 fails for player with same name" do
      assert {:error, {:already_started, _}} = Player.start_link(@player1)
    end

    test "player is registered on a tile with correct name and status" do
      [{{x, y}, _, %{name: @player1, status: :alive}}] =
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
  end

  describe "a player located in the center of the board" do
    setup do
      {:ok, _} = Player.start_link(@player1, fn -> {5, 5} end)

      :ok
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
      test "can move #{dir}" do
        :ok = Player.move(@player1, @dir)

        assert [] = Registry.lookup(@registry, @initial_pos)

        assert [{_, %{name: @player1, status: :alive}}] =
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
        {:ok, _} = Player.start_link(@player1, fn -> @initial_pos end)

        :ok = Player.move(@player1, @dir)

        assert [{_, %{name: @player1, status: :alive}}] = Registry.lookup(@registry, @initial_pos)
      end
    end
  end

  describe "a player located next to a wall" do
    values = [
      [{5, 6}, :up],
      [{5, 4}, :down],
      [{4, 5}, :left],
      [{6, 5}, :right]
    ]

    setup do
      {:ok, _} = Player.start_link(@player1, fn -> {5, 5} end)

      :ok
    end

    for [wall_pos, dir] <- values do
      @wall_pos wall_pos
      @dir dir
      test "can't move #{dir} through the wall" do
        :ok = Registry.put_meta(@registry, :walls, [@wall_pos])

        :ok = Player.move(@player1, @dir)

        assert [] = Registry.lookup(@registry, @wall_pos)
        assert [{_, %{name: @player1, status: :alive}}] = Registry.lookup(@registry, {5, 5})

        :ok = Registry.put_meta(@registry, :walls, [])
      end
    end
  end
end
