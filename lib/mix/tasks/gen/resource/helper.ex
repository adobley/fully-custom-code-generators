defmodule Mix.Tasks.Gen.Resource.Helper do
  defguard is_enum(values) when values not in [nil, []]

  def create_field_data(field_data) do
    fields_in_alphabetical_order =
      field_data
      |> Enum.sort_by(& &1.name)

    Enum.map_join(
      fields_in_alphabetical_order,
      "\n",
      fn
        field ->
          base_string =
            "field :#{underscore(field.name)}, #{ecto_type(field)}"

          if Map.get(field, :default) do
            base_string <> ", default: #{inspect(field.default)}"
          else
            base_string
          end
      end
    )
  end

  defp ecto_type(%{type: :string, options: values}) when is_enum(values) do
    "Ecto.Enum, values: #{inspect(values)}"
  end

  defp ecto_type(%{type: type}) do
    "#{inspect(type)}"
  end

  defp underscore(string) do
    string
    |> Macro.underscore()
    |> String.replace(" ", "_")
  end

  def migration_types(fields) do
    for field <- fields do
      "add :#{underscore(field.name)}, #{inspect(field.type)}"
    end
    |> Enum.join("\n")
  end
end
