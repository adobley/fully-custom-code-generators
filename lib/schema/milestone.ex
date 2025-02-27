defmodule Schema.Milestone do
  @moduledoc false
  use ArcaneAssist.Schema

  schema "milestones" do
    field :description, :string
    field :finish_date, :date
    field :start_date, :date

    field :status, Ecto.Enum,
      values: [:undiscovered, :discovered, :started, :finished],
      default: :undiscovered

    field :title, :string

    timestamps()
  end
end
