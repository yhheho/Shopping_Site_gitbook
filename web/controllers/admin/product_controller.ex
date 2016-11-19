defmodule ShoppingSite.Admin.ProductController do
  use ShoppingSite.Web, :controller

  alias ShoppingSite.Product

  import ShoppingSite.UserController, only: [authenticate: 2]
  plug :authenticate

  def index(conn, _params) do
    products = Repo.all(Product)
    render conn, "index.html", products: products
  end

  def new(conn, params) do
    changeset = Product.changeset(%Product{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"product" => product_params}) do
    changeset = Product.changeset(%Product{}, product_params)

    case Repo.insert(changeset) do
      {:ok, _product} ->
        conn
        |> put_flash(:info, "Add product successfully")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
