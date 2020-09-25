defmodule Wtt.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the PubSub system
      {Phoenix.PubSub, name: Wtt.PubSub}
      # Start a worker by calling: Wtt.Worker.start_link(arg)
      # {Wtt.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Wtt.Supervisor)
  end
end
