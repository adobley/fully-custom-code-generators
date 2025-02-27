defmodule Schema.Quest do
  @moduledoc false
  use ArcaneAssist.Schema

  schema "quests" do
    field :description, :string
    field :finish_date, :date
    field :start_date, :date
    field :status, Ecto.Enum, values: [:started, :unstarted, :finished], default: :unstarted
    field :title, :string

    timestamps()
  end
end
