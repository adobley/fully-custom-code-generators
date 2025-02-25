defmodule <%= live_view.name %>.LiveTest do
  use Web.ConnCase

  import Phoenix.LiveViewTest
  import Test.Factory

  <% {schema_name, schema} =  Enum.find(schemas, fn {_, schema} -> schema.generate_context_functions? end) %>

  @invalid_attrs %{ <%= helper.invalid_form_content_for(schema.fields) %> }

  defp create_<%= context.singular %>(_) do
    <%= context.singular %> = insert(:<%= schema.singular %>)
    %{<%= context.singular %>: <%= context.singular %>}
  end

  describe "Index" do
    setup [:create_<%= context.singular %>]

    test "lists all <%= context.plural %>", %{conn: conn, <%= context.singular %>: <%= context.singular %>} do
      {:ok, _index_live, html} = live(conn, ~p"/<%= context.plural %>")

      assert html =~ "Listing <%= String.capitalize(context.plural) %>"
    end

    test "saves new <%= context.singular %>", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/<%= context.plural %>")

      assert index_live |> element("a", "New <%= String.capitalize(context.singular) %>") |> render_click() =~
               "New <%= String.capitalize(context.singular) %>"

      assert_patch(index_live, ~p"/<%= context.plural %>/new")

      assert index_live
             |> form("#<%= context.singular %>-form", <%= context.singular %>: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#<%= context.singular %>-form", <%= context.singular %>: params_for(:<%= schema.singular %>))
             |> render_submit()

      assert_patch(index_live, ~p"/<%= context.plural %>")

      html = render(index_live)
      assert html =~ "<%= String.capitalize(context.singular) %> created successfully"
    end

    test "updates <%= context.singular %> in listing", %{conn: conn, <%= context.singular %>: <%= context.singular %>} do
      {:ok, index_live, _html} = live(conn, ~p"/<%= context.plural %>")

      assert index_live |> element("#<%= context.plural %>-#{<%= context.singular %>.id} a", "Edit") |> render_click() =~
               "Edit <%= String.capitalize(context.singular) %>"

      assert_patch(index_live, ~p"/<%= context.plural %>/#{<%= context.singular %>}/edit")

      assert index_live
             |> form("#<%= context.singular %>-form", <%= context.singular %>: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#<%= context.singular %>-form", <%= context.singular %>: params_for(:<%= schema.singular %>))
             |> render_submit()

      assert_patch(index_live, ~p"/<%= context.plural %>")

      html = render(index_live)
      assert html =~ "<%= String.capitalize(context.singular) %> updated successfully"
    end

    test "deletes <%= context.singular %> in listing", %{conn: conn, <%= context.singular %>: <%= context.singular %>} do
      {:ok, index_live, _html} = live(conn, ~p"/<%= context.plural %>")

      assert index_live |> element("#<%= context.plural %>-#{<%= context.singular %>.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#<%= context.plural %>-#{<%= context.singular %>.id}")
    end
  end

  describe "Show" do
    setup [:create_<%= context.singular %>]

    test "displays <%= context.singular %>", %{conn: conn, <%= context.singular %>: <%= context.singular %>} do
      {:ok, _show_live, html} = live(conn, ~p"/<%= context.plural %>/#{<%= context.singular %>}")

      assert html =~ "Show <%= String.capitalize(context.singular) %>"
    end

    test "updates <%= context.singular %> within modal", %{conn: conn, <%= context.singular %>: <%= context.singular %>} do
      {:ok, show_live, _html} = live(conn, ~p"/<%= context.plural %>/#{<%= context.singular %>}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit <%= String.capitalize(context.singular) %>"

      assert_patch(show_live, ~p"/<%= context.plural %>/#{<%= context.singular %>}/show/edit")

      assert show_live
             |> form("#<%= context.singular %>-form", <%= context.singular %>: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#<%= context.singular %>-form", <%= context.singular %>: params_for(:<%= schema.singular %>))
             |> render_submit()

      assert_patch(show_live, ~p"/<%= context.plural %>/#{<%= context.singular %>}")

      html = render(show_live)
      assert html =~ "<%= String.capitalize(context.singular) %> updated successfully"
    end
  end
end
