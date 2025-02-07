defmodule <%= Macro.camelize(schema_name) %> do
  @moduledoc false
  use Ecto.Schema

  schema "<%= schema.table %>" do
   <%= helper.create_field_data(schema.fields) %>
  end
end
