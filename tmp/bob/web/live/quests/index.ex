defmodule Web.Live.Quests.Index do
  use ArcaneAssistWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, stream(socket, :quests, Core.Quests.list_quests())}
  end

  def render(assigns) do
    dbg("This doesn't work yet, we need schema information to generate the table")

    ~H"""
    <.header>
      Listing Quests
      <:actions>
        <.link patch={~p"/quests/new"}>
          <.button>New Quest</.button>
        </.link>
      </:actions>
    </.header>

    <.table
      id="quests"
      rows={@streams.quests}
      row_click={fn {_id, quest} -> JS.navigate(~p"/quests/#{quest}") end}
    >
      <:col :let={{_id, quest}} label="Title">{quest.title}</:col>

      <:col :let={{_id, quest}} label="Description">{quest.description}</:col>

      <:col :let={{_id, quest}} label="Status">{quest.status}</:col>

      <:col :let={{_id, quest}} label="Start Date">{quest.start(date)}</:col>

      <:col :let={{_id, quest}} label="Finish Date">{quest.finish(date)}</:col>

      <:action :let={{_id, quest}}>
        <div class="sr-only">
          <.link navigate={~p"/quests/#{quest}"}>Show</.link>
        </div>
        <.link patch={~p"/quests/#{quest}/edit"}>Edit</.link>
      </:action>
      <:action :let={{id, quest}}>
        <.link
          phx-click={JS.push("delete", value: %{id: quest.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="quest-modal"
      show
      on_cancel={JS.patch(~p"/quests")}
    >
      <.live_component
        module={Web.Live.Quests.FormComponent}
        id={@quest.id || :new}
        title={@page_title}
        action={@live_action}
        quest={@quest}
        patch={~p"/quests"}
      />
    </.modal>
    """
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Quest")
    |> assign(:quest, Core.Quests.get_quest!(id))
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
  def handle_info({Web.Live.Quests.FormComponent, {:saved, quest}}, socket) do
    {:noreply, stream_insert(socket, :quests, quest)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    quest = Core.Quests.get_quest!(id)
    {:ok, _} = Core.Quests.delete_quest(quest)

    {:noreply, stream_delete(socket, :quests, quest)}
  end
end
