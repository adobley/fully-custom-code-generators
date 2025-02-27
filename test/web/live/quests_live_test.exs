defmodule Web.Live.Quests.LiveTest do
  use Web.ConnCase

  import Phoenix.LiveViewTest
  import Test.Factory

  @invalid_attrs %{title: nil}

  defp create_quest(_) do
    quest = insert(:quest)
    %{quest: quest}
  end

  describe "Index" do
    setup [:create_quest]

    test "lists all quests", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/quests")

      assert html =~ "Listing Quests"
    end

    test "saves new quest", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/quests")

      assert index_live |> element("a", "New Quest") |> render_click() =~
               "New Quest"

      assert_patch(index_live, ~p"/quests/new")

      assert index_live
             |> form("#quest-form", quest: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#quest-form", quest: params_for(:quest))
             |> render_submit()

      assert_patch(index_live, ~p"/quests")

      html = render(index_live)
      assert html =~ "Quest created successfully"
    end

    test "updates quest in listing", %{conn: conn, quest: quest} do
      {:ok, index_live, _html} = live(conn, ~p"/quests")

      assert index_live |> element("#quests-#{quest.id} a", "Edit") |> render_click() =~
               "Edit Quest"

      assert_patch(index_live, ~p"/quests/#{quest}/edit")

      assert index_live
             |> form("#quest-form", quest: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#quest-form", quest: params_for(:quest))
             |> render_submit()

      assert_patch(index_live, ~p"/quests")

      html = render(index_live)
      assert html =~ "Quest updated successfully"
    end

    test "deletes quest in listing", %{conn: conn, quest: quest} do
      {:ok, index_live, _html} = live(conn, ~p"/quests")

      assert index_live |> element("#quests-#{quest.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#quests-#{quest.id}")
    end
  end

  describe "Show" do
    setup [:create_quest]

    test "displays quest", %{conn: conn, quest: quest} do
      {:ok, _show_live, html} = live(conn, ~p"/quests/#{quest}")

      assert html =~ "Show Quest"
    end

    test "updates quest within modal", %{conn: conn, quest: quest} do
      {:ok, show_live, _html} = live(conn, ~p"/quests/#{quest}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Quest"

      assert_patch(show_live, ~p"/quests/#{quest}/show/edit")

      assert show_live
             |> form("#quest-form", quest: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#quest-form", quest: params_for(:quest))
             |> render_submit()

      assert_patch(show_live, ~p"/quests/#{quest}")

      html = render(show_live)
      assert html =~ "Quest updated successfully"
    end
  end
end
