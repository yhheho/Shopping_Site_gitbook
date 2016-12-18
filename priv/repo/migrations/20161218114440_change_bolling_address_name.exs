defmodule ShoppingSite.Repo.Migrations.ChangeBollingAddressName do
  use Ecto.Migration

  def change do
    rename table(:order_infos), :bolling_address, to: :billing_address
  end
end
