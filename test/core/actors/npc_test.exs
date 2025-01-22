defmodule Core.Actors.NPCTest do
  use ArcaneAssist.DataCase

  alias Core.Actors

  describe "npcs" do
    import ArcaneAssist.ActorsFixtures

    @invalid_attrs %{name: nil}

    test "list_npcs/0 returns all npcs" do
      npc = npc_fixture()
      assert Actors.NPC.list_npcs() == [npc]
    end

    test "get_npc!/1 returns the npc with given id" do
      npc = npc_fixture()
      assert Actors.NPC.get_npc!(npc.id) == npc
    end

    test "create_npc/1 with valid data creates a npc" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Schema.NPC{} = npc} = Actors.NPC.create_npc(valid_attrs)
      assert npc.name == "some name"
    end

    test "create_npc/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Actors.NPC.create_npc(@invalid_attrs)
    end

    test "update_npc/2 with valid data updates the npc" do
      npc = npc_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Schema.NPC{} = npc} = Actors.NPC.update_npc(npc, update_attrs)
      assert npc.name == "some updated name"
    end

    test "update_npc/2 with invalid data returns error changeset" do
      npc = npc_fixture()
      assert {:error, %Ecto.Changeset{}} = Actors.NPC.update_npc(npc, @invalid_attrs)
      assert npc == Actors.NPC.get_npc!(npc.id)
    end

    test "delete_npc/1 deletes the npc" do
      npc = npc_fixture()
      assert {:ok, %Schema.NPC{}} = Actors.NPC.delete_npc(npc)
      assert_raise Ecto.NoResultsError, fn -> Actors.NPC.get_npc!(npc.id) end
    end

    test "change_npc/1 returns a npc changeset" do
      npc = npc_fixture()
      assert %Ecto.Changeset{} = Actors.NPC.change_npc(npc)
    end
  end
end
