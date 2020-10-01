defmodule WttWeb.Router do
  use WttWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/player", WttWeb do
    pipe_through :api

    put "/:name/move/:dir", PlayerController, :move
    put "/:name/attack", PlayerController, :attack
    post "/:name", PlayerController, :create
    post "/", PlayerController, :create
  end

  scope "/board", WttWeb do
    pipe_through :api

    get "/", BoardController, :get
  end

  scope "/", WttWeb do
    pipe_through :browser

    get "/*path", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", WttWeb do
  #   pipe_through :api
  # end
end
