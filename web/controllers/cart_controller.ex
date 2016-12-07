defmodule ShoppingSite.CartController do
  use ShoppingSite.Web, :controller

  def current_cart(conn) do
    conn.assigns.current_cart
  end

  def index(conn, _params) do
    cart_id = get_session(conn, :cart_id)
    current_cart = current_cart(conn)

    products = Repo.preload(current_cart, :products).products
    render conn, "index.html", products: products
  end

end
