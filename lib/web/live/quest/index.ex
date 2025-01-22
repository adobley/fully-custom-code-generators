defmodule Web.Live.Quest.Index do
  use ArcaneAssistWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :quests, Core.Quest.list_quests())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Quest")
    |> assign(:quest, Core.Quest.get_quest!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Quest")
    |> assign(:quest, %Schema.Quest{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Quests")
    |> assign(:quest, nil)
  end

  @impl true
  def handle_info({Web.Live.Quest.FormComponent, {:saved, quest}}, socket) do
    {:noreply, stream_insert(socket, :quests, quest)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    quest = Core.Quest.get_quest!(id)
    {:ok, _} = Core.Quest.delete_quest(quest)

    {:noreply, stream_delete(socket, :quests, quest)}
  end
end
