defmodule WttWeb.PlayerView do
  use WttWeb, :view

  def render("player.json", %{player: player}) do
    %{player: player}
  end
end
