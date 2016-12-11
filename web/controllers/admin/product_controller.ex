defmodule ShoppingSite.Admin.ProductController do
  use ShoppingSite.Web, :controller

  alias ShoppingSite.Product
  alias ShoppingSite.PhotoUploader

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

  def edit(conn, %{"id" => id}) do
    product = Repo.get!(Product, id)
    changeset = Product.changset(product)
    render conn, "edit.html", product: product, changeset: changeset
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Repo.get!(Product, id)
    changeset = Product.changeset(product, product_params)

    case Repo.update(changeset) do
      {:ok, _product} ->
        conn
        |> put_flash(:info, "Update product successfully.")
        |> redirect(to: admin_product_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", product: product, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Repo.get!(ShoppingSite.Product, id)
    Repo.delete!(product)

    PhotoUploader.delete(product.photo.file_name) #delete all file contains file_name
    conn
      |> redirect(to: admin_product_path(conn, :list_view))
  end

  def list_view(conn, _params) do
    products = Repo.all(Product)
    render conn, "list_view.html", products: products
  end


end
