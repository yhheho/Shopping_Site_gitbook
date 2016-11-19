defmodule ShoppingSite.Product do
  use ShoppingSite.Web, :model

  use Arc.Ecto.Schema

  schema "products" do
    field :title, :string
    field :description, :string
    field :quantity, :integer
    field :price, :integer

    field :photo, ShoppingSite.PhotoUploader.Type

    timestamps()
  end

  @required_fields ~w(title description quantity price)
  @optional_fields ~w()

  @required_photo_fields ~w()
  @optional_photo_fields ~w(photo)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description, :quantity, :price])
    |> cast_attachments(params, [:photo])
    |> validate_required([:title, :description, :quantity, :price])
    |> validate_length(:description, max: 200)
  end
end
