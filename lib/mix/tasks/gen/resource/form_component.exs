defmodule <%= live_view.name %>.FormComponent do
  use ArcaneAssistWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage <%= context.singular %> records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="<%= context.singular %>-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <%= helper.inputs_for(live_view.fields) %>
        <:actions>
          <.button phx-disable-with="Saving...">Save <%= String.capitalize(context.singular) %></.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{<%= context.singular %>: <%= context.singular %>} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(<%= context.name %>.change_<%= context.singular %>(<%= context.singular %>))
     end)}
  end

  @impl true
  def handle_event("validate", %{"<%= context.singular %>" => <%= context.singular %>_params}, socket) do
    changeset = <%= context.name %>.change_<%= context.singular %>(socket.assigns.<%= context.singular %>, <%= context.singular %>_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"<%= context.singular %>" => <%= context.singular %>_params}, socket) do
    save_<%= context.singular %>(socket, socket.assigns.action, <%= context.singular %>_params)
  end

  defp save_<%= context.singular %>(socket, :edit, <%= context.singular %>_params) do
    case <%= context.name %>.update_<%= context.singular %>(socket.assigns.<%= context.singular %>, <%= context.singular %>_params) do
      {:ok, <%= context.singular %>} ->
        notify_parent({:saved, <%= context.singular %>})

        {:noreply,
         socket
         |> put_flash(:info, "<%= String.capitalize(context.singular) %> updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_<%= context.singular %>(socket, :new, <%= context.singular %>_params) do
    case <%= context.name %>.create_<%= context.singular %>(<%= context.singular %>_params) do
      {:ok, <%= context.singular %>} ->
        notify_parent({:saved, <%= context.singular %>})

        {:noreply,
         socket
         |> put_flash(:info, "<%= String.capitalize(context.singular) %> created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
