defmodule WttWeb.PageController do
  use WttWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
