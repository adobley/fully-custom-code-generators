defmodule Schema.Quest do
  use Ecto.Schema

  schema "quests" do
    field :title, :string
    field :description, :string
    field :status, Ecto.Enum, values: [:unstarted, :started, :finished]
    field :start_time, :utc_datetime
    field :finish_time, :utc_datetime, source: :end_time

    many_to_many :npcs, Schema.NPC, join_through: "quests_npcs"
    timestamps(type: :utc_datetime)
  end
end
