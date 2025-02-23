defmodule Test.Factory do
  use ExMachina.Ecto, repo: Core.Repo

  alias Schema.NPC

  # data generation

  def date_random, do: Date.utc_today() |> Date.shift(day: Enum.random(-30..30))
  def string, do: Faker.String.base64()

  # schemas

  def npc_factory() do
    %NPC{
      name: string()
    }
  end
end
