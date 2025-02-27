defmodule Test.Factory do
  use ExMachina.Ecto, repo: Core.Repo

  alias Schema.Milestone
  alias Schema.NPC
  alias Schema.Quest

  # data generation

  def date_random, do: Date.utc_today() |> Date.shift(day: Enum.random(-30..30))
  def string, do: Faker.String.base64()

  # schemas

  def npc_factory() do
    %NPC{
      name: string()
    }
  end

  def milestone_factory do
    %Milestone{
      description: string(),
      finish_date: date_random(),
      start_date: date_random(),
      status: Enum.random([:undiscovered, :discovered, :started, :finished]) |> Atom.to_string(),
      title: string()
    }
  end

  def quest_factory do
    %Quest{
      description: string(),
      finish_date: date_random(),
      start_date: date_random(),
      status: Enum.random([:started, :unstarted, :finished]) |> Atom.to_string(),
      title: string()
    }
  end
end
