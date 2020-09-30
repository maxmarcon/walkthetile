defmodule Wtt.TestUtils do
  @moduledoc false

  @supervisor Wtt.PlayerSupervisor

  def terminate_all_players do
    for {_, pid, _, _} <- DynamicSupervisor.which_children(@supervisor) do
      :ok = DynamicSupervisor.terminate_child(@supervisor, pid)
    end
  end
end
