defmodule <%= context.name %>Test do
  use ArcaneAssist.DataCase

  alias <%= context.name %>

  import ArcaneAssist.Fixtures

  <%= for {schema_name, schema} <- schemas, schema.generate_context_functions? do %>
    # TODO: Everywhere we see "name" in this file needs to be updated when we have schema in our doc
    # or possibly it should call out to a factory for valid/invailid?
    @invalid_attrs %{name: DateTime.utc_now()}

    describe "list/<%= schema.plural %>/0" do
      test "success: returns all <%= schema.plural %>" do
        <%= schema.singular %> = <%= schema.singular %>_fixture()
        assert <%= String.capitalize(schema.plural) %>.list_<%= schema.plural %>() == [<%= schema.singular %>]
      end
    end

    describe "get_<%= schema.singular %>!/1" do
      test "success: returns the <%= schema.singular %> with given id" do
        <%= schema.singular %> = <%= schema.singular %>_fixture()
        assert <%= String.capitalize(schema.plural) %>.get_<%= schema.singular %>!(<%= schema.singular %>.id) == <%= schema.singular %>
      end
    end

    describe "create_<%= schema.singular %>/1" do
      test "success: with valid data creates a <%= schema.singular %>" do
        valid_attrs = %{name: "some name"}

        assert {:ok, %<%= schema_name %>{} = <%= schema.singular %>} = <%= String.capitalize(schema.plural) %>.create_<%= schema.singular %>(valid_attrs)
        assert <%= schema.singular %>.name == "some name"
      end

      test "success: with invalid data returns error changeset" do
        assert {:error, %Ecto.Changeset{}} = <%= String.capitalize(schema.plural) %>.create_<%= schema.singular %>(@invalid_attrs)
      end
    end

    describe "update_<%= schema.singular %>/2" do
      test "success: with valid data updates the <%= schema.singular %>" do
        <%= schema.singular %> = <%= schema.singular %>_fixture()
        update_attrs = %{name: "some updated name"}

        assert {:ok, %<%= schema_name %>{} = <%= schema.singular %>} = <%= String.capitalize(schema.plural) %>.update_<%= schema.singular %>(<%= schema.singular %>, update_attrs)
        assert <%= schema.singular %>.name == "some updated name"
      end

      test "error: returns changeset with errors" do
        <%= schema.singular %> = <%= schema.singular %>_fixture()
        assert {:error, %Ecto.Changeset{}} = <%= String.capitalize(schema.plural) %>.update_<%= schema.singular %>(<%= schema.singular %>, @invalid_attrs)
        assert <%= schema.singular %> == <%= String.capitalize(schema.plural) %>.get_<%= schema.singular %>!(<%= schema.singular %>.id)
      end
    end

    describe "delete_<%= schema.singular %>/1" do
      test "success: deletes the <%= schema.singular %>" do
        <%= schema.singular %> = <%= schema.singular %>_fixture()
        assert {:ok, %<%= schema_name %>{}} = <%= String.capitalize(schema.plural) %>.delete_<%= schema.singular %>(<%= schema.singular %>)
        assert_raise Ecto.NoResultsError, fn -> <%= String.capitalize(schema.plural) %>.get_<%= schema.singular %>!(<%= schema.singular %>.id) end
      end
    end

    describe "change_<%= schema.singular %>/1" do
      test "success: returns a <%= schema.singular %> changeset" do
        <%= schema.singular %> = <%= schema.singular %>_fixture()
        assert %Ecto.Changeset{} = <%= String.capitalize(schema.plural) %>.change_<%= schema.singular %>(<%= schema.singular %>)
      end

      test "error: returns invalid changeset when given bad data" do
        <%= schema.singular %> = <%= schema.singular %>_fixture()

        assert changeset = %Ecto.Changeset{valid?: false} = <%= String.capitalize(schema.plural) %>.change_<%= schema.singular %>(<%= schema.singular %>, @invalid_attrs)

        errors = errors_on(changeset)

        for {field, _} <- @invalid_attrs do
          assert Enum.member?(errors, {field, ["is invalid"]})
        end
      end
    end
  <% end %>
end
