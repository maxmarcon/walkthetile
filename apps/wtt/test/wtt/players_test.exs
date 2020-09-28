defmodule Wtt.PlayersTest do
  @moduledoc false
  alias Wtt.Players

  @player1 "player_1"

  use ExUnit.Case

  describe "ensure_player_started/1" do
    test "can start a new player" do
      assert :ok = Players.ensure_player_started(@player1)
      assert :ok = Players.ensure_player_started(@player1)
    end
  end
end
