defmodule Core.QuestsTest do
  use ArcaneAssist.DataCase

  alias Core.Quests

  import ArcaneAssist.Fixtures

  # TODO: Everywhere we see "name" in this file needs to be updated when we have schema in our doc
  # or possibly it should call out to a factory for valid/invailid?
  @invalid_attrs %{name: DateTime.utc_now()}

  describe "list/quests/0" do
    test "success: returns all quests" do
      quest = quest_fixture()
      assert Quests.list_quests() == [quest]
    end
  end

  describe "get_quest!/1" do
    test "success: returns the quest with given id" do
      quest = quest_fixture()
      assert Quests.get_quest!(quest.id) == quest
    end
  end

  describe "create_quest/1" do
    test "success: with valid data creates a quest" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Schema.Quest{} = quest} = Quests.create_quest(valid_attrs)
      assert quest.name == "some name"
    end

    test "success: with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Quests.create_quest(@invalid_attrs)
    end
  end

  describe "update_quest/2" do
    test "success: with valid data updates the quest" do
      quest = quest_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Schema.Quest{} = quest} = Quests.update_quest(quest, update_attrs)
      assert quest.name == "some updated name"
    end

    test "error: returns changeset with errors" do
      quest = quest_fixture()
      assert {:error, %Ecto.Changeset{}} = Quests.update_quest(quest, @invalid_attrs)
      assert quest == Quests.get_quest!(quest.id)
    end
  end

  describe "delete_quest/1" do
    test "success: deletes the quest" do
      quest = quest_fixture()
      assert {:ok, %Schema.Quest{}} = Quests.delete_quest(quest)
      assert_raise Ecto.NoResultsError, fn -> Quests.get_quest!(quest.id) end
    end
  end

  describe "change_quest/1" do
    test "success: returns a quest changeset" do
      quest = quest_fixture()
      assert %Ecto.Changeset{} = Quests.change_quest(quest)
    end

    test "error: returns invalid changeset when given bad data" do
      quest = quest_fixture()

      assert changeset =
               %Ecto.Changeset{valid?: false} = Quests.change_quest(quest, @invalid_attrs)

      errors = errors_on(changeset)

      for {field, _} <- @invalid_attrs do
        assert Enum.member?(errors, {field, ["is invalid"]})
      end
    end
  end
end
