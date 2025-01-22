defmodule Web.Live.Quest.Show do
  use ArcaneAssistWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:quest, Core.Quest.get_quest!(id))}
  end

  defp page_title(:show), do: "Show Quest"
  defp page_title(:edit), do: "Edit Quest"
end
