defmodule <%= Macro.camelize(schema_name) %> do
  @moduledoc false
  use ArcaneAssist.Schema

  schema "<%= schema.table %>" do
    <%= helper.create_field_data(schema.fields) %>
  end
end
