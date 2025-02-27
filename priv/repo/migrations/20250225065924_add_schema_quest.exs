defmodule Core.Repo.Migrations.CreateQuests do
  use Ecto.Migration

  def change do
    create table(:quests, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :description, :string
      add :status, :string
      add :start_date, :date
      add :finish_date, :date
      timestamps(type: :utc_datetime_usec)
    end
  end

  # don't forget to add indices if needed
end
