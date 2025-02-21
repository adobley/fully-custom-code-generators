defmodule Web.Live.NPCs.NPCsLiveTest do
  use Web.ConnCase

  import Phoenix.LiveViewTest

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_npc(_) do
    npc = insert(:npc)
    %{npc: npc}
  end

  describe "Index" do
    setup [:create_npc]

    test "lists all npcs", %{conn: conn, npc: npc} do
      {:ok, _index_live, html} = live(conn, ~p"/npcs")

      assert html =~ "Listing Npcs"
      assert html =~ npc.name
    end

    test "saves new npc", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/npcs")

      assert index_live |> element("a", "New Npc") |> render_click() =~
               "New Npc"

      assert_patch(index_live, ~p"/npcs/new")

      assert index_live
             |> form("#npc-form", npc: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#npc-form", npc: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/npcs")

      html = render(index_live)
      assert html =~ "Npc created successfully"
      assert html =~ "some name"
    end

    test "updates npc in listing", %{conn: conn, npc: npc} do
      {:ok, index_live, _html} = live(conn, ~p"/npcs")

      assert index_live |> element("#npcs-#{npc.id} a", "Edit") |> render_click() =~
               "Edit Npc"

      assert_patch(index_live, ~p"/npcs/#{npc}/edit")

      assert index_live
             |> form("#npc-form", npc: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#npc-form", npc: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/npcs")

      html = render(index_live)
      assert html =~ "Npc updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes npc in listing", %{conn: conn, npc: npc} do
      {:ok, index_live, _html} = live(conn, ~p"/npcs")

      assert index_live |> element("#npcs-#{npc.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#npcs-#{npc.id}")
    end
  end

  describe "Show" do
    setup [:create_npc]

    test "displays npc", %{conn: conn, npc: npc} do
      {:ok, _show_live, html} = live(conn, ~p"/npcs/#{npc}")

      assert html =~ "Show Npc"
      assert html =~ npc.name
    end

    test "updates npc within modal", %{conn: conn, npc: npc} do
      {:ok, show_live, _html} = live(conn, ~p"/npcs/#{npc}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Npc"

      assert_patch(show_live, ~p"/npcs/#{npc}/show/edit")

      assert show_live
             |> form("#npc-form", npc: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#npc-form", npc: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/npcs/#{npc}")

      html = render(show_live)
      assert html =~ "Npc updated successfully"
      assert html =~ "some updated name"
    end
  end
end
