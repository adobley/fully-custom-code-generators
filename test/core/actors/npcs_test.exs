defmodule Core.Actors.NPCsTest do
  use ArcaneAssist.DataCase

  alias Core.Actors.NPCs

  @invalid_attrs %{name: DateTime.utc_now()}

  describe "list/npcs/0" do
    test "success: returns all npcs" do
      npc = insert(:npc)
      assert NPCs.list_npcs() == [npc]
    end
  end

  describe "get_npc!/1" do
    test "success: returns the npc with given id" do
      npc = insert(:npc)
      assert NPCs.get_npc!(npc.id) == npc
    end
  end

  describe "create_npc/1" do
    test "success: with valid data creates a npc" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Schema.NPC{} = npc} = NPCs.create_npc(valid_attrs)
      assert npc.name == "some name"
    end

    test "success: with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = NPCs.create_npc(@invalid_attrs)
    end
  end

  describe "update_npc/2" do
    test "success: with valid data updates the npc" do
      npc = insert(:npc)
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Schema.NPC{} = npc} = NPCs.update_npc(npc, update_attrs)
      assert npc.name == "some updated name"
    end

    test "error: returns changeset with errors" do
      npc = insert(:npc)
      assert {:error, %Ecto.Changeset{}} = NPCs.update_npc(npc, @invalid_attrs)
      assert npc == NPCs.get_npc!(npc.id)
    end
  end

  describe "delete_npc/1" do
    test "success: deletes the npc" do
      npc = insert(:npc)
      assert {:ok, %Schema.NPC{}} = NPCs.delete_npc(npc)
      assert_raise Ecto.NoResultsError, fn -> NPCs.get_npc!(npc.id) end
    end
  end

  describe "change_npc/1" do
    test "success: returns a npc changeset" do
      npc = insert(:npc)
      assert %Ecto.Changeset{} = NPCs.change_npc(npc)
    end

    test "error: returns invalid changeset when given bad data" do
      npc = insert(:npc)

      assert changeset = %Ecto.Changeset{valid?: false} = NPCs.change_npc(npc, @invalid_attrs)

      errors = errors_on(changeset)

      for {field, _} <- @invalid_attrs do
        assert Enum.member?(errors, {field, ["is invalid"]})
      end
    end
  end
end
