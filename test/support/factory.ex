defmodule Test.Factory do
  use ExMachina.Ecto, repo: Core.Repo

  alias Schema.NPC

  def npc_factory() do
    %NPC{
      name: Faker.String.base64()
    }
  end
end
