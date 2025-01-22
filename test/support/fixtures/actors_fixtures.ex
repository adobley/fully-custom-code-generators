defmodule ArcaneAssist.ActorsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ArcaneAssist.Actors` context.
  """

  @doc """
  Generate a npc.
  """
  def npc_fixture(attrs \\ %{}) do
    {:ok, npc} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Core.Actors.NPC.create_npc()

    npc
  end
end
