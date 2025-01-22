defmodule Core.Actors.NPC do
  @moduledoc """
  NPC access
  """

  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias Schema.NPC

  @doc """
  Returns the list of npcs.

  ## Examples

      iex> list_npcs()
      [%NPC{}, ...]

  """
  def list_npcs do
    Core.Repo.all(NPC)
  end

  @doc """
  Gets a single npc.

  Raises `Ecto.NoResultsError` if the Npc does not exist.

  ## Examples

      iex> get_npc!(123)
      %NPC{}

      iex> get_npc!(456)
      ** (Ecto.NoResultsError)

  """
  def get_npc!(id), do: Core.Repo.get!(NPC, id)

  @doc """
  Creates a npc.

  ## Examples

      iex> create_npc(%{field: value})
      {:ok, %NPC{}}

      iex> create_npc(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_npc(attrs \\ %{}) do
    %NPC{}
    |> changeset(attrs)
    |> Core.Repo.insert()
  end

  @doc """
  Updates a npc.

  ## Examples

      iex> update_npc(npc, %{field: new_value})
      {:ok, %NPC{}}

      iex> update_npc(npc, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_npc(%NPC{} = npc, attrs) do
    npc
    |> changeset(attrs)
    |> Core.Repo.update()
  end

  @doc """
  Deletes a npc.

  ## Examples

      iex> delete_npc(npc)
      {:ok, %NPC{}}

      iex> delete_npc(npc)
      {:error, %Ecto.Changeset{}}

  """
  def delete_npc(%NPC{} = npc) do
    Core.Repo.delete(npc)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking npc changes.

  ## Examples

      iex> change_npc(npc)
      %Ecto.Changeset{data: %NPC{}}

  """
  def change_npc(%NPC{} = npc, attrs \\ %{}) do
    changeset(npc, attrs)
  end

  @doc false
  def changeset(npc, attrs) do
    npc
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
