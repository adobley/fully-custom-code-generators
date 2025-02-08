defmodule Schema.NPC do
  use ArcaneAssist.Schema

  schema "npcs" do
    field :name, :string

    many_to_many :quests, Schema.Quest, join_through: "quests_npcs"
    timestamps type: :utc_datetime
  end
end
