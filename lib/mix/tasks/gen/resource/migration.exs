defmodule Core.Repo.Migrations.Create<%= Macro.camelize(table) %> do
  use Ecto.Migration

  def change do
    create table(:<%= table %>, primary_key: false) do
    add :id, :binary_id, primary_key: true
    <%= helper.migration_types(fields) %>
    timestamps(type: :utc_datetime_usec)
    end
  end

  # don't forget to add indices if needed
end
