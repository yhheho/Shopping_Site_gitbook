defmodule ShoppingSite.CartController do
  use ShoppingSite.Web, :controller

  def current_cart(conn) do
    conn.assigns.current_cart
  end

end
