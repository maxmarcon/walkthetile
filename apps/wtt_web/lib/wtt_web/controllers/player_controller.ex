defmodule WttWeb.PlayerController do
  use WttWeb, :controller

  alias Wtt.Game
  alias Wtt.Player

  action_fallback WttWeb.FallbackController

  def create(conn, %{"name" => name}) do
    {:ok, name} = Game.ensure_player_started(name)

    render(conn, :player, %{player: name})
  end

  def create(conn, _params) do
    {:ok, name} = Game.ensure_player_started()

    render(conn, :player, %{player: name})
  end

  def move(conn, %{"name" => name, "dir" => dir}) do
    case Player.move(name, String.to_atom(dir)) do
      :ok -> :ok
      {:error, :invalid_direction} -> {:error, :bad_request}
      error -> {:error, :internal_server_error}
    end
  end

  def attack(conn, %{"name" => name}) do
    Player.attack(name)
  end
end
