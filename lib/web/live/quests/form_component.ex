defmodule Web.Live.Quests.FormComponent do
  use ArcaneAssistWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage quest records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="quest-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />

        <.input field={@form[:description]} type="text" label="Description" />

        <.input
          field={@form[:status]}
          type="select"
          label="Status"
          options={[{"Unstarted", :unstarted}, {"Started", :started}, {"Finished", :finished}]}
        />

        <.input field={@form[:start_date]} type="date" label="Start Date" />

        <.input field={@form[:finish_date]} type="date" label="Finish Date" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Quest</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{quest: quest} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Core.Quests.change_quest(quest))
     end)}
  end

  @impl true
  def handle_event("validate", %{"quest" => quest_params}, socket) do
    changeset = Core.Quests.change_quest(socket.assigns.quest, quest_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"quest" => quest_params}, socket) do
    save_quest(socket, socket.assigns.action, quest_params)
  end

  defp save_quest(socket, :edit, quest_params) do
    case Core.Quests.update_quest(socket.assigns.quest, quest_params) do
      {:ok, quest} ->
        notify_parent({:saved, quest})

        {:noreply,
         socket
         |> put_flash(:info, "Quest updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_quest(socket, :new, quest_params) do
    case Core.Quests.create_quest(quest_params) do
      {:ok, quest} ->
        notify_parent({:saved, quest})

        {:noreply,
         socket
         |> put_flash(:info, "Quest created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
