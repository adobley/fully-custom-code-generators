defmodule Web.Live.Quests.Show do
  use ArcaneAssistWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    dbg("This doesn't work yet, we need schema information to generate the table")

    ~H"""
    <.header>
      Quest {@quest.id}
      <:subtitle>This is a quest record from your database.</:subtitle>
      <:actions>
        <.link patch={~p"/quests/#{@quest}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit quest</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Title">{@quest.title}</:item>
      <:item title="Description">{@quest.description}</:item>
      <:item title="Status">{@quest.status}</:item>
      <:item title="Start Time">{@quest.start_time}</:item>
      <:item title="Finish Time">{@quest.finish_time}</:item>
    </.list>

    <.back navigate={~p"/quests"}>Back to quests</.back>

    <.modal
      :if={@live_action == :edit}
      id="quest-modal"
      show
      on_cancel={JS.patch(~p"/quests/#{@quest}")}
    >
      <.live_component
        module={Web.Live.Quests.FormComponent}
        id={@quest.id}
        title={@page_title}
        action={@live_action}
        quest={@quest}
        patch={~p"/quests/#{@quest}"}
      />
    </.modal>
    """
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:quest, Core.Quests.get_quest!(id))}
  end

  defp page_title(:show), do: "Show Quest"
  defp page_title(:edit), do: "Edit Quest"
end
