defmodule ShoppingSite.Cart do
  use ShoppingSite.Web, :model

  alias ShoppingSite.Repo

  schema "carts" do

    has_many :cart_items, ShoppingSite.CartItem, on_delete: :delete_all
    has_many :products, through: [:cart_items, :product]

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end

  def clean_cart_items(cart) do
    Repo.preload(cart, :cart_items).cart_items
      |> Enum.map(& Repo.delete(&1))
  end
end
