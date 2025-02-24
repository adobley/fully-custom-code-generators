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
          base_string = "field :#{underscore(field.name)}, #{ecto_type(field)}"

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

  def required_fields(fields) do
    fields
    |> Enum.filter(&Map.get(&1, :required?, false))
    |> Enum.map(& &1.name)
    |> Enum.map(&String.to_atom/1)
  end

  def cols_for(context_singular, fields) do
    Enum.map_join(fields, "\n", &col_for(context_singular, &1))
  end

  def col_for(context_singular, field) do
    label = title_case(field.name)

    """
    <:col :let={{_id, #{context_singular}}} label="#{label}">{#{context_singular}.#{snake_case(field.name)}}</:col>
    """
  end

  def fields_for(context_singular, fields) do
    Enum.map_join(fields, "\n", &field_for(context_singular, &1))
  end

  def field_for(context_singular, field) do
    label = title_case(field.name)

    """
    <:item title="#{label}">{@#{context_singular}.#{snake_case(field.name)}}</:item>
    """
  end

  def inputs_for(fields) do
    Enum.map_join(fields, "\n", &input_for/1)
  end

  def input_for(%{type: :select} = field) do
    label = title_case(field.name)

    options =
      Enum.map_join(field.options, ", ", &inspect({&1 |> Atom.to_string() |> title_case(), &1}))

    """
    <.input field={@form[:#{snake_case(field.name)}]} type="select" label="#{label}" options={[#{options}]} />
    """
  end

  def input_for(field) do
    label = title_case(field.name)

    """
    <.input field={@form[:#{snake_case(field.name)}]} type="#{field.type}" label="#{label}" />
    """
  end

  def factory_function_and_alias({schema_name, schema_data}) do
    aliased_module_name = String.split(schema_name, ".") |> List.last()

    """
      alias #{schema_name}

      def #{Macro.underscore(aliased_module_name)}_factory do
        %#{aliased_module_name}{
          #{create_factory_data(schema_data.fields, aliased_module_name)}
        }
      end
    """
  end

  def create_factory_data(field_data, aliased_module_name) do
    fields_in_alphabetical_order = Enum.sort_by(field_data, & &1.name)

    Enum.map_join(
      fields_in_alphabetical_order,
      ",\n",
      fn field ->
        field_name = underscore(field.name)
        "  #{field_name}: #{factory_function(field)}"
      end
    )
  end

  def factory_function(%{options: options}) do
    "Enum.random(#{inspect(options)}) |> Atom.to_string()"
  end

  def factory_function(%{type: :string}) do
    "string()"
  end

  def factory_function(%{type: :date}) do
    "date_random()"
  end

  def factory_function(field_data) do
    raise """

    This table has a field that we're not sure how to handle yet!
    Head over to lib/mix/tasks/resource/helper.ex and add a new factory_function that matches this field info:

    #{inspect(field_data)}
    """
  end

  defp title_case(string) do
    string
    |> String.split(" ")
    |> Enum.map_join(" ", &String.capitalize/1)
  end

  defp snake_case(string), do: String.replace(string, " ", "_")

  def invalid_attrs_for(fields) do
    Enum.map_join(fields, ",\n", &invalid_attr_for/1)
  end

  defp invalid_attr_for(field) do
    "#{snake_case(field.name)}: #{invalid_factory_function(field)}"
  end


  def invalid_factory_function(%{options: _}) do
    "date_random()"
  end

  def invalid_factory_function(%{type: :string}) do
    "date_random()"
  end

  def invalid_factory_function(%{type: :date}) do
    "string()"
  end

  def invalid_factory_function(field_data) do
    raise """

    This table has a field that we're not sure how to handle yet!
    Head over to lib/mix/tasks/resource/helper.ex and add a new invalid_factory_function that matches this field info:

    #{inspect(field_data)}
    """
  end
end
