defmodule Core.Repo.Migrations.CreateNpcs do
  use Ecto.Migration

  def change do
    create table(:npcs) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
