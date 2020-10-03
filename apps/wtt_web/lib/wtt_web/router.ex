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

  scope "/api", WttWeb do
    pipe_through :api

    put "/player/:name/move/:dir", PlayerController, :move
    put "/player/:name/attack", PlayerController, :attack
    post "/player/:name", PlayerController, :create
    post "/player/", PlayerController, :create
    get "/board", BoardController, :get
  end

  scope "/", WttWeb do
    pipe_through :browser

    get "/game", PageController, :index
    get "/*path", PageController, :redirect_to_game
  end
end
