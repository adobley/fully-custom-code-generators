defmodule Schema.NPC do
  use ArcaneAssist.Schema

  schema "npcs" do
    field :name, :string

    timestamps type: :utc_datetime
  end
end
