defmodule ShoppingSite.Order do
  use ShoppingSite.Web, :model

  schema "orders" do
    field :total, :integer
    belongs_to :user, ShoppingSite.User

    has_many :items, ShoppingSite.OrderItem, on_delete: :delete_all
    has_one :info, ShoppingSite.OrderInfo, on_delete: :delete_all

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:total])
    |> validate_required([:total])
  end
end
