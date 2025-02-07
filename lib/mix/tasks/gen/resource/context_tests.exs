defmodule <%= context.name %>Test do
  use ArcaneAssist.DataCase

  alias <%= context.name %>

  import ArcaneAssist.Fixtures

  # TODO: Everywhere we see "name" in this file needs to be updated when we have schema in our doc
  # or possibly it should call out to a factory for valid/invailid?
  @invalid_attrs %{name: DateTime.utc_now()}

  describe "list/<%= context.plural %>/0" do
    test "success: returns all <%= context.plural %>" do
      <%= context.singular %> = <%= context.singular %>_fixture()
      assert <%= String.capitalize(context.plural) %>.list_<%= context.plural %>() == [<%= context.singular %>]
    end
  end

  describe "get_<%= context.singular %>!/1" do
    test "success: returns the <%= context.singular %> with given id" do
      <%= context.singular %> = <%= context.singular %>_fixture()
      assert <%= String.capitalize(context.plural) %>.get_<%= context.singular %>!(<%= context.singular %>.id) == <%= context.singular %>
    end
  end

  describe "create_<%= context.singular %>/1" do
    test "success: with valid data creates a <%= context.singular %>" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Schema.<%= String.capitalize(context.singular) %>{} = <%= context.singular %>} = <%= String.capitalize(context.plural) %>.create_<%= context.singular %>(valid_attrs)
      assert <%= context.singular %>.name == "some name"
    end

    test "success: with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = <%= String.capitalize(context.plural) %>.create_<%= context.singular %>(@invalid_attrs)
    end
  end

  describe "update_<%= context.singular %>/2" do
    test "success: with valid data updates the <%= context.singular %>" do
      <%= context.singular %> = <%= context.singular %>_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Schema.<%= String.capitalize(context.singular) %>{} = <%= context.singular %>} = <%= String.capitalize(context.plural) %>.update_<%= context.singular %>(<%= context.singular %>, update_attrs)
      assert <%= context.singular %>.name == "some updated name"
    end

    test "error: returns changeset with errors" do
      <%= context.singular %> = <%= context.singular %>_fixture()
      assert {:error, %Ecto.Changeset{}} = <%= String.capitalize(context.plural) %>.update_<%= context.singular %>(<%= context.singular %>, @invalid_attrs)
      assert <%= context.singular %> == <%= String.capitalize(context.plural) %>.get_<%= context.singular %>!(<%= context.singular %>.id)
    end
  end

  describe "delete_<%= context.singular %>/1" do
    test "success: deletes the <%= context.singular %>" do
      <%= context.singular %> = <%= context.singular %>_fixture()
      assert {:ok, %Schema.<%= String.capitalize(context.singular) %>{}} = <%= String.capitalize(context.plural) %>.delete_<%= context.singular %>(<%= context.singular %>)
      assert_raise Ecto.NoResultsError, fn -> <%= String.capitalize(context.plural) %>.get_<%= context.singular %>!(<%= context.singular %>.id) end
    end
  end

  describe "change_<%= context.singular %>/1" do
    test "success: returns a <%= context.singular %> changeset" do
      <%= context.singular %> = <%= context.singular %>_fixture()
      assert %Ecto.Changeset{} = <%= String.capitalize(context.plural) %>.change_<%= context.singular %>(<%= context.singular %>)
    end

    test "error: returns invalid changeset when given bad data" do
      <%= context.singular %> = <%= context.singular %>_fixture()

      assert changeset = %Ecto.Changeset{valid?: false} = <%= String.capitalize(context.plural) %>.change_<%= context.singular %>(<%= context.singular %>, @invalid_attrs)

      errors = errors_on(changeset)

      for {field, _} <- @invalid_attrs do
        assert Enum.member?(errors, {field, ["is invalid"]})
      end
    end
  end
end
