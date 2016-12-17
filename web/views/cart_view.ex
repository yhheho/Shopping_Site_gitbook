defmodule ShoppingSite.CartView do
  use ShoppingSite.Web,  :view

  alias ShoppingSite.Cart
  alias ShoppingSite.Repo

  import ShoppingSite.CartController, only: [current_cart: 1]

  def cart_total_price(conn) do
    # cart_id = Plug.Conn.get_session(conn, :cart_id)
    current_cart = ShoppingSite.CartController.current_cart(conn)

    Repo.preload(current_cart, :products).products
    |> Enum.map(& &1.price)
    |> Enum.sum
  end

  def get_cart_items(conn) do
    products =
      Repo.preload(current_cart(conn), :products).products
  end

  def cart_total_price(conn) do
    Repo.preload(current_cart(conn), :cart_items).cart_items
      |> Repo.preload(:product)
      |> Enum.reduce(0, fn x, acc ->
                      (x.product.price * x.quantity) + acc end)
  end
end
