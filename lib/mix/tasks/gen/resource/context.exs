defmodule <%= context.name %> do
  @moduledoc false
  import Ecto.Changeset
  import Ecto.Query, warn: false

  <%= for {schema_name, schema} <- schemas, schema.generate_context_functions? do %>
    alias <%= schema_name %>

    @doc """
    Returns the list of <%= schema.plural %>.

    ## Examples

        iex> list_<%= schema.plural %>()
        [%<%= String.capitalize(schema.singular) %>{}, ...]

    """
    def list_<%= schema.plural %> do
      Core.Repo.all(<%= String.capitalize(schema.singular) %>)
    end

    @doc """
    Gets a single <%= schema.singular %>.

    Raises `Ecto.NoResultsError` if the Npc does not exist.

    ## Examples

        iex> get_<%= schema.singular %>!(123)
        %<%= String.capitalize(schema.singular) %>{}

        iex> get_<%= schema.singular %>!(456)
        ** (Ecto.NoResultsError)

    """
    def get_<%= schema.singular %>!(id), do: Core.Repo.get!(<%= String.capitalize(schema.singular) %>, id)

    @doc """
    Creates a <%= schema.singular %>.

    ## Examples

        iex> create_<%= schema.singular %>(%{field: value})
        {:ok, %<%= String.capitalize(schema.singular) %>{}}

        iex> create_<%= schema.singular %>(%{field: bad_value})
        {:error, %Ecto.Changeset{}}

    """
    def create_<%= schema.singular %>(attrs \\ %{}) do
      %<%= String.capitalize(schema.singular) %>{}
      |> changeset(attrs)
      |> Core.Repo.insert()
    end

    @doc """
    Updates a <%= schema.singular %>.

    ## Examples

        iex> update_<%= schema.singular %>(<%= schema.singular %>, %{field: new_value})
        {:ok, %<%= String.capitalize(schema.singular) %>{}}

        iex> update_<%= schema.singular %>(<%= schema.singular %>, %{field: bad_value})
        {:error, %Ecto.Changeset{}}

    """
    def update_<%= schema.singular %>(%<%= String.capitalize(schema.singular) %>{} = <%= schema.singular %>, attrs) do
      <%= schema.singular %>
      |> changeset(attrs)
      |> Core.Repo.update()
    end

    @doc """
    Deletes a <%= schema.singular %>.

    ## Examples

        iex> delete_<%= schema.singular %>(<%= schema.singular %>)
        {:ok, %<%= String.capitalize(schema.singular) %>{}}

        iex> delete_<%= schema.singular %>(<%= schema.singular %>)
        {:error, %Ecto.Changeset{}}

    """
    def delete_<%= schema.singular %>(%<%= String.capitalize(schema.singular) %>{} = <%= schema.singular %>) do
      Core.Repo.delete(<%= schema.singular %>)
    end

    @doc """
    Returns an `%Ecto.Changeset{}` for tracking <%= schema.singular %> changes.

    ## Examples

        iex> change_<%= schema.singular %>(<%= schema.singular %>)
        %Ecto.Changeset{data: %<%= String.capitalize(schema.singular) %>{}}

    """
    def change_<%= schema.singular %>(%<%= String.capitalize(schema.singular) %>{} = <%= schema.singular %>, attrs \\ %{}) do
      changeset(<%= schema.singular %>, attrs)
    end

    @doc false
    def changeset(<%= schema.singular %>, attrs) do
      <%= schema.singular %>
      |> cast(attrs, <%= String.capitalize(schema.singular) %>.__schema__(:fields))
      |> validate_required(<%= inspect(helper.required_fields(schema.fields)) %>)
    end
  <% end %>
end
