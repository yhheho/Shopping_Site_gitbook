defmodule ShoppingSite.Router do
  use ShoppingSite.Web, :router

  #gitbook shoppingSite


  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ShoppingSite.Auth, repo: ShoppingSite.Repo
    plug ShoppingSite.CartPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ShoppingSite do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/products", ProductController, only: [:show, :index] do
      get "/add_to_cart", ProductController, :add_to_cart, as: :add_to_cart
    end

    resources "/carts", CartController, only: [:index]
  end

  scope "/admin", ShoppingSite.Admin, as: :admin do
    pipe_through :browser

    resources "/products", ProductController
  end

  # Other scopes may use custom stacks.
  # scope "/api", ShoppingSite do
  #   pipe_through :api
  # end
end
