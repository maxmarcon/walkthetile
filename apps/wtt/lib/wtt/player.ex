defmodule Wtt.Player do
  @moduledoc false
  use GenServer
  import Wtt.Board
  import Registry

  @registry Wtt.Registry.Board
  @board_size Application.get_env(:wtt, :board_size)

  def start_link(name, initial_tile \\ &random_tile/0) when is_function(initial_tile, 0) do
    GenServer.start_link(__MODULE__, [name, initial_tile])
  end

  @impl true
  def init([name, initial_tile]) when is_function(initial_tile) do
    {:ok, _} = register(@registry, name, [])
    {:ok, move_to_initial_pos(initial_tile.(), %{name: name, status: :alive})}
  end

  @impl true
  def handle_call(:up, _from, state = %{pos: {x, y}}) do
    {:reply, :ok, move_to_new_pos({x, y + 1}, state)}
  end

  @impl true
  def handle_call(:down, _from, state = %{pos: {x, y}}) do
    {:reply, :ok, move_to_new_pos({x, y - 1}, state)}
  end

  @impl true
  def handle_call(:left, _from, state = %{pos: {x, y}}) do
    {:reply, :ok, move_to_new_pos({x - 1, y}, state)}
  end

  @impl true
  def handle_call(:right, _from, state = %{pos: {x, y}}) do
    {:reply, :ok, move_to_new_pos({x + 1, y}, state)}
  end

  @impl true
  def handle_cast(:up, state) do
    {:noreply, state}
  end

  defp move_to_new_pos(new_pos, state = %{name: name, status: status, pos: pos}) do
    new_pos =
      if valid_position?(new_pos) do
        new_pos
      else
        pos
      end

    :ok = unregister(@registry, pos)
    {:ok, _} = register(@registry, new_pos, %{name: name, status: status})
    %{state | pos: new_pos}
  end

  defp move_to_initial_pos(new_pos, state = %{name: name, status: status}) do
    {:ok, _} = register(@registry, new_pos, %{name: name, status: status})
    Map.put(state, :pos, new_pos)
  end
  
  defp valid_position?({x, y}) do
    x >= 1 && x <= @board_size && y >= 1 && y <= @board_size
  end
  
  defp random_tile() do
    random_tile(walls())
  end

  defp walls() do
    {:ok, walls} = meta(@registry, :walls)
    walls
  end
end
