defmodule ShoppingSite.UserController do
  use ShoppingSite.Web, :controller

  alias ShoppingSite.User

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> ShoppingSite.Auth.login(user) #param 1 is already conn
        |> put_flash(:info, "#{user.username} created")
        |> redirect(to: page_path(conn, :index))

      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  defp authenticate(conn, _params) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must login")
      |> redirect(to: page_path(conn, :index))
      |> halt
    end
  end

end
