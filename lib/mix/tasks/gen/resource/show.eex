defmodule <%= live_view.name %>.Show do
  use ArcaneAssistWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    dbg("This doesn't work yet, we need schema information to generate the table")
    ~H"""
    <.header>
    <%= String.capitalize(context.singular) %> {@<%= context.singular %>.id}
    <:subtitle>This is a <%= context.singular %> record from your database.</:subtitle>
    <:actions>
        <.link patch={~p"/<%= context.plural %>/#{@<%= context.singular %>}/show/edit"} phx-click={JS.push_focus()}>
        <.button>Edit <%= context.singular %></.button>
        </.link>
    </:actions>
    </.header>

    <.list>
    <:item title="Title">{@<%= context.singular %>.title}</:item>
    <:item title="Description">{@<%= context.singular %>.description}</:item>
    <:item title="Status">{@<%= context.singular %>.status}</:item>
    <:item title="Start Time">{@<%= context.singular %>.start_time}</:item>
    <:item title="Finish Time">{@<%= context.singular %>.finish_time}</:item>
    </.list>

    <.back navigate={~p"/<%= context.plural %>"}>Back to <%= context.plural %></.back>

    <.modal :if={@live_action == :edit} id="<%= context.singular %>-modal" show on_cancel={JS.patch(~p"/<%= context.plural %>/#{@<%= context.singular %>}")}>
    <.live_component
        module={<%= live_view.name %>.FormComponent}
        id={@<%= context.singular %>.id}
        title={@page_title}
        action={@live_action}
        <%= context.singular %>={@<%= context.singular %>}
        patch={~p"/<%= context.plural %>/#{@<%= context.singular %>}"}
    />
    </.modal>
    """
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:<%= context.singular %>, <%= context.name %>.get_<%= context.singular %>!(id))}
  end

  defp page_title(:show), do: "Show <%= String.capitalize(context.singular) %>"
  defp page_title(:edit), do: "Edit <%= String.capitalize(context.singular) %>"
end
