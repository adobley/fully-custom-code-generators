defmodule Core.Repo.Migrations.QuestsHaveQuestgivers do
  use Ecto.Migration

  def change do
    create table(:quests_npcs, primary_key: false) do
      add :quest_id, references(:quests, type: :binary_id)
      add :npc_id, references(:npcs, type: :binary_id)
    end

    create unique_index(:quests_npcs, [:quest_id, :npc_id])
  end
end
