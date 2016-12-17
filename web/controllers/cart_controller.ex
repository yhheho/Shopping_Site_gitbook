defmodule ShoppingSite.CartController do
  use ShoppingSite.Web, :controller

  alias ShoppingSite.OrderInfo
  alias ShoppingSite.Order

  def current_cart(conn) do
    conn.assigns.current_cart
  end

  def index(conn, _params) do
    cart_id = get_session(conn, :cart_id)
    current_cart = current_cart(conn)

    products = Repo.preload(current_cart, :products).products
    render conn, "index.html", products: products
  end

  def check_out(conn, _params) do
    order_info_changeset = OrderInfo.changeset(%OrderInfo{})
    order_changeset = Order.changeset(%Order{info: order_info_changeset})
    render conn, "check_out.html", order_changeset: order_changeset
  end

end
