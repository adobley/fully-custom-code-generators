defmodule <%= live_view.name %>.Index do
  use ArcaneAssistWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, stream(socket, :<%= context.plural %>, <%= context.name %>.list_<%= context.plural %>())}
  end

  def render(assigns) do
    dbg("This doesn't work yet, we need schema information to generate the table")
    ~H"""
    <.header>
    Listing <%= String.capitalize(context.plural) %>
    <:actions>
        <.link patch={~p"/<%= context.plural %>/new"}>
        <.button>New <%= String.capitalize(context.singular) %></.button>
        </.link>
    </:actions>
    </.header>

    <.table
    id="<%= context.plural %>"
    rows={@streams.<%= context.plural %>}
    row_click={fn {_id, <%= context.singular %>} -> JS.navigate(~p"/<%= context.plural %>/#{<%= context.singular %>}") end}
    >
    <%= helper.cols_for(context.singular, live_view.fields) %>
    <:action :let={{_id, <%= context.singular %>}}>
        <div class="sr-only">
        <.link navigate={~p"/<%= context.plural %>/#{<%= context.singular %>}"}>Show</.link>
        </div>
        <.link patch={~p"/<%= context.plural %>/#{<%= context.singular %>}/edit"}>Edit</.link>
    </:action>
    <:action :let={{id, <%= context.singular %>}}>
        <.link
        phx-click={JS.push("delete", value: %{id: <%= context.singular %>.id}) |> hide("##{id}")}
        data-confirm="Are you sure?"
        >
        Delete
        </.link>
    </:action>
    </.table>

    <.modal :if={@live_action in [:new, :edit]} id="<%= context.singular %>-modal" show on_cancel={JS.patch(~p"/<%= context.plural %>")}>
    <.live_component
        module={<%= live_view.name %>.FormComponent}
        id={@<%= context.singular %>.id || :new}
        title={@page_title}
        action={@live_action}
        <%= context.singular %>={@<%= context.singular %>}
        patch={~p"/<%= context.plural %>"}
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
    |> assign(:page_title, "Edit <%= String.capitalize(context.singular) %>")
    |> assign(:<%= context.singular %>, <%= context.name %>.get_<%= context.singular %>!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New <%= String.capitalize(context.singular) %>")
    |> assign(:<%= context.singular %>, %Schema.<%= String.capitalize(context.singular) %>{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing <%= String.capitalize(context.plural) %>")
    |> assign(:<%= context.singular %>, nil)
  end

  @impl true
  def handle_info({<%= live_view.name %>.FormComponent, {:saved, <%= context.singular %>}}, socket) do
    {:noreply, stream_insert(socket, :<%= context.plural %>, <%= context.singular %>)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    <%= context.singular %> = <%= context.name %>.get_<%= context.singular %>!(id)
    {:ok, _} = <%= context.name %>.delete_<%= context.singular %>(<%= context.singular %>)

    {:noreply, stream_delete(socket, :<%= context.plural %>, <%= context.singular %>)}
  end
end
