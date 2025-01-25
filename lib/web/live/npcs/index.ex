defmodule Web.Live.NPCs.Index do
  use ArcaneAssistWeb, :live_view

  alias Core.Actors

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :npcs, Actors.NPCs.list_npcs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Npc")
    |> assign(:npc, Actors.NPCs.get_npc!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Npc")
    |> assign(:npc, %Schema.NPC{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Npcs")
    |> assign(:npc, nil)
  end

  @impl true
  def handle_info({Web.Live.NPCs.FormComponent, {:saved, npc}}, socket) do
    {:noreply, stream_insert(socket, :npcs, npc)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    npc = Actors.NPCs.get_npc!(id)
    {:ok, _} = Actors.NPCs.delete_npc(npc)

    {:noreply, stream_delete(socket, :npcs, npc)}
  end
end
