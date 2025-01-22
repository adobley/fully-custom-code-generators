defmodule Core.Repo.Migrations.CreateQuests do
  use Ecto.Migration

  def change do
    create table(:quests) do
      add :title, :string
      add :description, :string
      add :status, :string
      add :start_time, :timestamp
      add :end_time, :timestamp

      timestamps(type: :utc_datetime)
    end
  end
end
