defmodule ShoppingSite.Admin.UserController do
  use ShoppingSite.Web, :controller

  alias ShoppingSite.User

  import ShoppingSite.UserController, only: [authenticate: 2]
  plug :authenticate


  def index(conn, _params) do
    users = Repo.all(User)
    render conn, "index.html", users: users
  end
end
