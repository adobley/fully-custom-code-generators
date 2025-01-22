defmodule Core.Repo.Migrations.QuestsHaveQuestgivers do
  use Ecto.Migration

  def change do
    create table(:quests_npcs) do
      add :quest_id, references(:quests)
      add :npc_id, references(:npcs)
    end

    create unique_index(:quests_npcs, [:quest_id, :npc_id])
  end
end
