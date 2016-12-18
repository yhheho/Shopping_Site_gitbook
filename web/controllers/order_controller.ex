defmodule ShoppingSite.OrderController do
  use ShoppingSite.Web, :controller

  require Logger
  alias ShoppingSite.Order
  alias ShoppingSite.OrderItem
  alias ShoppingSite.Repo

  import ShoppingSite.UserController, only: [authenticate: 2]
  import ShoppingSite.CartController, only: [current_cart: 1]
  plug :authenticate when action in [:create]

  def create(conn, %{"order" => order_params}) do

    IO.inspect order_params

    new_order_params =
      order_params
        |> Map.put("user_id", Integer.to_string(conn.assigns.current_user.id))
        |> Map.put("total", Integer.to_string(get_total_price(conn)))

    order_changeset =
      Order.changeset(%Order{}, new_order_params)

    Logger.debug "order_changeset"
    IO.inspect order_changeset


    if order_changeset.valid? do
      case Repo.insert(order_changeset) do
        {:ok, order} ->
          build_order_item(conn, order)
          ShoppingSite.Cart.clean_cart_items(current_cart(conn))
          conn
            |> put_flash(:info, "Order created successfully")
            |> redirect(to: cart_path(conn, :index))
        {:error, order_changeset} ->
          render(conn, "index.html", changeset: order_changeset)
      end
    else
      conn
        |> put_flash(:warning, "something wrong")
        |> redirect(to: cart_path(conn, :index))
    end
  end

  def get_total_price(conn) do
    Repo.preload(current_cart(conn), :cart_items).cart_items
      |> Repo.preload(:product)
      |> Enum.map(& &1.product.price)
      |> Enum.sum
  end

  def build_order_item(conn, order) do

    products =
      Repo.preload(current_cart(conn), :cart_items).cart_items
        |> Repo.preload(:product)
        |> Enum.map(& &1.product)
        #|> Enum.map(fn x -> %{product: x.product, quantity: x.quantity} end)
    IO.puts "after gettingggggg products"
    ##quantity

    for item <- products do
      order_item_changeset =
        build_assoc(order, :items)
          # |> OrderItem.changeset(%{"product_name" => item[:product].title,
          #                          "price" => item[:product].price,
          #                          "quantity" => 1})
          |> OrderItem.changeset(%{"product_name" => item.title,
                                   "price" => item.price,
                                   "quantity" => 1})
          IO.puts "after creatingggggg ordetitem"
      case Repo.insert(order_item_changeset) do
        {:ok, _order_item} ->
          conn
        {:error, _changeset} ->
          render(conn, "show.html")
      end
    end
  end
end
