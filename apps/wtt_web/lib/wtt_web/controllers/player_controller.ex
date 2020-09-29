defmodule WttWeb.PlayerController do
  use WttWeb, :controller

  alias Wtt.Game
  alias Wtt.Game.Player

  action_fallback WttWeb.FallbackController

  def create(conn, %{"name" => name}) do
    {:ok, name} = Game.ensure_player_started(name)

    render(conn, :player, %{player: name})
  end

  def create(conn, _params) do
    {:ok, name} = Game.ensure_player_started()

    render(conn, :player, %{player: name})
  end
end
