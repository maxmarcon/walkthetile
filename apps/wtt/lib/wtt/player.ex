defmodule Wtt.Player do
  @moduledoc false
  use GenServer
  import Wtt.Board

  @registry Wtt.Registry.Board
  @board_size Application.get_env(:wtt, :board_size)
  @msec_to_live_after_killed 5000

  @spec start_link(binary(), (() -> Board.tile())) :: GenServer.on_start()
  def start_link(name, initial_tile \\ &random_tile/0) when is_function(initial_tile, 0) do
    GenServer.start_link(__MODULE__, [name, initial_tile], name: {:global, name})
  end

  @spec move(binary(), :left | :right | :up | :down) :: term()
  def move(name, dir) when dir in [:left, :right, :up, :down] do
    GenServer.call({:global, name}, dir)
  end

  def move(_name, _dir), do: {:error, :invalid_direction}

  @spec kill(pid()) :: :ok
  def kill(pid) do
    GenServer.cast(pid, :kill)
  end

  @spec attack(binary()) :: term()
  def attack(name) do
    GenServer.call({:global, name}, :attack)
  end

  @spec child_spec([binary() | list()]) :: Supervisor.child_spec()
  def child_spec([name | _] = args) do
    %{
      id: name,
      start: {__MODULE__, :start_link, args}
    }
  end

  @spec child_spec(binary()) :: Supervisor.child_spec()
  def child_spec(name) do
    child_spec([name])
  end

  @impl true
  def init([name, initial_tile]) when is_function(initial_tile) do
    {:ok, move_to_initial_tile(initial_tile.(), %{name: name, status: :alive})}
  end
  
  @impl true
  def handle_call(_, _, %{status: :dead} = state) do
    {:reply, :ok, state}
  end

  @impl true
  def handle_call(:up, _from, state = %{tile: {x, y}}) do
    {:reply, :ok, move_to_new_tile({x, y + 1}, state)}
  end

  @impl true
  def handle_call(:down, _from, state = %{tile: {x, y}}) do
    {:reply, :ok, move_to_new_tile({x, y - 1}, state)}
  end

  @impl true
  def handle_call(:left, _from, state = %{tile: {x, y}}) do
    {:reply, :ok, move_to_new_tile({x - 1, y}, state)}
  end

  @impl true
  def handle_call(:right, _from, state = %{tile: {x, y}}) do
    {:reply, :ok, move_to_new_tile({x + 1, y}, state)}
  end

  @impl true
  def handle_call(:attack, _from, state = %{tile: {x, y}}) do
    for tx <- [x, x + 1, x - 1] do
      for ty <- [y, y + 1, y - 1] do
        for {pid, _} <- Registry.lookup(@registry, {tx, ty}), pid != self() do
          :ok = __MODULE__.kill(pid)
        end
      end
    end

    {:reply, :ok, state}
  end

  @impl true
  def handle_cast(_, %{status: :dead} = state) do
    {:noreply, state}
  end
  
  @impl true
  def handle_cast(:kill, state = %{tile: tile}) do
    new_state = %{state | status: :dead}
    :ok = Registry.unregister(@registry, tile)
    {:ok, _} = Registry.register(@registry, tile, Map.delete(new_state, :tile))

    {:ok, death_task} =
      Task.start_link(fn ->
        Process.sleep(@msec_to_live_after_killed)
      end)

    death_task_ref = Process.monitor(death_task)
    {:noreply, Map.put(new_state, :death_task_ref, death_task_ref)}
  end

  @impl true
  def handle_info(
        {:DOWN, death_task_ref, :process, _, :normal},
        state = %{death_task_ref: death_task_ref}
      ) do
    {:stop, :normal, state}
  end

  defp move_to_new_tile(new_tile, state = %{name: name, status: status, tile: tile}) do
    if valid_tile?(new_tile) do
      :ok = Registry.unregister(@registry, tile)
      {:ok, _} = Registry.register(@registry, new_tile, %{name: name, status: status})
      %{state | tile: new_tile}
    else
      state
    end
  end

  defp move_to_initial_tile(new_tile, state = %{name: name, status: status}) do
    {:ok, _} = Registry.register(@registry, new_tile, %{name: name, status: status})
    Map.put(state, :tile, new_tile)
  end

  defp valid_tile?({x, y} = tile) do
    x >= 1 && x <= @board_size && y >= 1 && y <= @board_size && !(tile in walls())
  end

  defp random_tile() do
    random_tile(walls())
  end

  defp walls() do
    {:ok, walls} = Registry.meta(@registry, :walls)
    walls
  end
end
