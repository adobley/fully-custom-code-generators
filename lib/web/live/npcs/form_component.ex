defmodule Web.Live.NPCs.FormComponent do
  use ArcaneAssistWeb, :live_component

  alias Core.Actors

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage npc records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="npc-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Npc</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{npc: npc} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Actors.NPCs.change_npc(npc))
     end)}
  end

  @impl true
  def handle_event("validate", %{"npc" => npc_params}, socket) do
    changeset = Actors.NPCs.change_npc(socket.assigns.npc, npc_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"npc" => npc_params}, socket) do
    save_npc(socket, socket.assigns.action, npc_params)
  end

  defp save_npc(socket, :edit, npc_params) do
    case Actors.NPCs.update_npc(socket.assigns.npc, npc_params) do
      {:ok, npc} ->
        notify_parent({:saved, npc})

        {:noreply,
         socket
         |> put_flash(:info, "Npc updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_npc(socket, :new, npc_params) do
    case Actors.NPCs.create_npc(npc_params) do
      {:ok, npc} ->
        notify_parent({:saved, npc})

        {:noreply,
         socket
         |> put_flash(:info, "Npc created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
