defmodule Wtt.Application do
  import Wtt.Board
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Registry, keys: :duplicate, meta: board_registry_metadata(), name: Wtt.Registry.Board},
      {DynamicSupervisor, strategy: :one_for_one, max_restarts: 1000, name: Wtt.PlayerSupervisor}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Wtt.Supervisor)
  end

  defp board_registry_metadata() do
    [
      walls: generate_walls()
    ]
  end
end
