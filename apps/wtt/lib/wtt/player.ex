defmodule Wtt.Player do
  @moduledoc false
  use GenServer

  @registry Wtt.Registry.Board
  @board_size Application.get_env(:wtt, :board_size)

  def start_link(name) do
    GenServer.start_link(__MODULE__, name)
  end

  @impl true
  def init(name) do
    pos = random_tile()
    {:ok, _} = Registry.register(@registry, pos, [])
    {:ok, %{name: name, pos: pos, status: :alive}}
  end

  @impl true
  def handle_call(:get_state, _from, state = %{name: name, status: status}) do
    {:reply, {name, status}, state}
  end

  @impl true
  def handle_cast(_msg, state) do
    {:noreply, state}
  end

  defp random_tile() do
    1..@board_size
    |> Stream.flat_map(fn x ->
      1..@board_size |> Stream.map(&{x, &1})
    end)
    |> Stream.reject(&(&1 in walls()))
    |> Enum.random()
  end

  defp walls() do
    {:ok, walls} = Registry.meta(@registry, :walls)
    walls
  end
end
