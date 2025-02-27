defmodule Core.QuestsTest do
  use ArcaneAssist.DataCase

  import Test.Factory

  alias Core.Quests

  @invalid_attrs %{
    title: date_random(),
    description: date_random(),
    status: date_random(),
    start_date: string(),
    finish_date: string()
  }

  describe "list/quests/0" do
    test "success: returns all quests" do
      quest = insert(:quest)
      assert Quests.list_quests() == [quest]
    end
  end

  describe "get_quest!/1" do
    test "success: returns the quest with given id" do
      quest = insert(:quest)
      assert Quests.get_quest!(quest.id) == quest
    end
  end

  describe "create_quest/1" do
    test "success: with valid data creates a quest" do
      valid_attrs = params_for(:quest)

      assert {:ok, %Schema.Quest{}} = Quests.create_quest(valid_attrs)
    end

    test "success: with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Quests.create_quest(@invalid_attrs)
    end
  end

  describe "update_quest/2" do
    test "success: with valid data updates the quest" do
      quest = insert(:quest)
      update_attrs = params_for(:quest)

      assert {:ok, %Schema.Quest{}} = Quests.update_quest(quest, update_attrs)
    end

    test "error: returns changeset with errors" do
      quest = insert(:quest)
      assert {:error, %Ecto.Changeset{}} = Quests.update_quest(quest, @invalid_attrs)
      assert quest == Quests.get_quest!(quest.id)
    end
  end

  describe "delete_quest/1" do
    test "success: deletes the quest" do
      quest = insert(:quest)
      assert {:ok, %Schema.Quest{}} = Quests.delete_quest(quest)
      assert_raise Ecto.NoResultsError, fn -> Quests.get_quest!(quest.id) end
    end
  end

  describe "change_quest/1" do
    test "success: returns a quest changeset" do
      quest = insert(:quest)
      assert %Ecto.Changeset{} = Quests.change_quest(quest)
    end

    test "error: returns invalid changeset when given bad data" do
      quest = insert(:quest)

      assert changeset =
               %Ecto.Changeset{valid?: false} = Quests.change_quest(quest, @invalid_attrs)

      errors = errors_on(changeset)

      for {field, _} <- @invalid_attrs do
        assert Enum.member?(errors, {field, ["is invalid"]})
      end
    end
  end
end
