defmodule ShoppingSite.Admin.UserController do
  use ShoppingSite.Web, :controller

  alias ShoppingSite.User

  import ShoppingSite.UserController, only: [authenticate: 2]
  plug :authenticate


  def index(conn, _params) do
    users = Repo.all(User)
    render conn, "index.html", users: users
  end

  def change_authority(conn, %{"id" => id}) do
    extracted_user = Repo.get!(ShoppingSite.User, id)
    Ecto.Changeset.change(extracted_user, %{admin: !extracted_user.admin})
      |> Repo.update

    users = Repo.all(ShoppingSite.User)
    conn
      |> render("index.html", users: users)
  end

end
