defmodule Mix.Tasks.Gen.Resource do
  @shortdoc "context, live view, schema, and migration generator"
  @moduledoc false
  use Mix.Task

  alias Mix.Tasks.Format
  alias Mix.Tasks.Gen.Resource.Helper

  @impl Mix.Task
  def run([input_filename]) do
    Agent.start_link(fn -> DateTime.now!("Etc/UTC") end, name: :timestamp_agent)

    {live_view_params_from_file, _binding = []} = Code.eval_file(input_filename)

    live_view_params =
      Keyword.put(
        live_view_params_from_file,
        :helper,
        Helper
      )

    generators = [
      :generate_migrations,
      :generate_schemas,
      :generate_context,
      :generate_context_tests,
      :generate_live_index,
      :generate_live_show,
      :generate_live_edit,
      :generate_live_view_tests,
      :output_factory_functions
    ]

    new_files =
      Enum.map(generators, fn generator ->
        apply(__MODULE__, generator, [live_view_params])
      end)

    Format.run(List.flatten(new_files))
  end

  def generate_context(live_view_params) do
    generated_file_contents =
      eval_from(
        "lib/mix/tasks/gen/resource/context.exs",
        live_view_params
      )

    module_as_filename =
      live_view_params
      |> get_in([:context, :name])
      |> module_name_as_path()

    output_filename = "lib/#{module_as_filename}.ex"

    Mix.Generator.create_file(output_filename, generated_file_contents, force: true)

    output_filename
  end

  def generate_context_tests(live_view_params) do
    generated_file_contents =
      eval_from(
        "lib/mix/tasks/gen/resource/context_tests.exs",
        live_view_params
      )

    module_as_filename =
      live_view_params
      |> get_in([:context, :name])
      |> module_name_as_path()

    output_filename = "test/#{module_as_filename}_test.exs"

    Mix.Generator.create_file(output_filename, generated_file_contents, force: true)

    output_filename
  end

  def generate_live_index(live_view_params) do
    actions = get_in(live_view_params, [:live_view, :actions])

    if Enum.any?([:index, :new, :edit], &(&1 in actions)) do
      generated_file_contents =
        eval_from(
          "lib/mix/tasks/gen/resource/index.exs",
          live_view_params
        )

      module_as_filename =
        live_view_params
        |> get_in([:live_view, :name])
        |> Kernel.<>(".Index")
        |> module_name_as_path()

      output_filename = "lib/#{module_as_filename}.ex"

      Mix.Generator.create_file(output_filename, generated_file_contents, force: true)

      [output_filename]
    else
      []
    end
  end

  def generate_live_show(live_view_params) do
    actions = get_in(live_view_params, [:live_view, :actions])

    if Enum.any?([:index, :new, :edit], &(&1 in actions)) do
      generated_file_contents =
        eval_from(
          "lib/mix/tasks/gen/resource/show.exs",
          live_view_params
        )

      module_as_filename =
        live_view_params
        |> get_in([:live_view, :name])
        |> Kernel.<>(".Show")
        |> module_name_as_path()

      output_filename = "lib/#{module_as_filename}.ex"

      Mix.Generator.create_file(output_filename, generated_file_contents, force: true)

      [output_filename]
    else
      []
    end
  end

  def generate_live_edit(live_view_params) do
    actions = get_in(live_view_params, [:live_view, :actions])

    if Enum.any?([:index, :new, :edit], &(&1 in actions)) do
      generated_file_contents =
        eval_from(
          "lib/mix/tasks/gen/resource/form_component.exs",
          live_view_params
        )

      module_as_filename =
        live_view_params
        |> get_in([:live_view, :name])
        |> Kernel.<>(".FormComponent")
        |> module_name_as_path()

      output_filename = "lib/#{module_as_filename}.ex"

      Mix.Generator.create_file(output_filename, generated_file_contents, force: true)

      [output_filename]
    else
      []
    end
  end

  def generate_live_view_tests(live_view_params) do
    actions = get_in(live_view_params, [:live_view, :actions])

    if Enum.any?([:index, :new, :edit], &(&1 in actions)) do
      generated_file_contents =
        eval_from(
          "lib/mix/tasks/gen/resource/live_view_tests.exs",
          live_view_params
        )

      module_as_filename =
        live_view_params
        |> get_in([:live_view, :name])
        |> Kernel.<>("LiveTest")
        |> module_name_as_path()

      output_filename = "test/#{module_as_filename}.exs"

      Mix.Generator.create_file(output_filename, generated_file_contents, force: true)

      [output_filename]
    else
      []
    end
  end

  def generate_migrations(live_view_params) do
    for {schema_name, schema_data} <- live_view_params[:schemas] do
      file_name =
        ("#{generate_timestamp()}_add_" <> schema_name)
        |> String.downcase()
        |> String.replace(".", "_")

      migration_params =
        schema_data
        |> Map.put(:table, schema_data[:table])
        |> Map.put(:helper, Mix.Tasks.Gen.Resource.Helper)
        |> Map.to_list()

      generated_file_contents =
        eval_from(
          "lib/mix/tasks/gen/resource/migration.exs",
          migration_params
        )

      output_filename = "priv/repo/migrations/#{file_name}.exs"

      Mix.Generator.create_file(output_filename, generated_file_contents, force: true)

      output_filename
    end
  end

  def generate_schemas(live_view_params) do
    for {schema_name, schema_data} <- live_view_params[:schemas] do
      live_view_params =
        live_view_params
        |> Keyword.put(:schema_name, schema_name)
        |> Keyword.put(:schema, schema_data)

      generated_file_contents =
        eval_from(
          "lib/mix/tasks/gen/resource/schema.exs",
          live_view_params
        )

      module_as_filename =
        schema_name
        |> module_name_as_path()

      output_filename = "lib/#{module_as_filename}.ex"

      Mix.Generator.create_file(output_filename, generated_file_contents, force: true)

      output_filename
    end
  end

  def output_factory_functions(live_view_params) do
    functions_and_aliases =
      for schema_things <- live_view_params[:schemas] do
        Helper.factory_function_and_alias(schema_things)
      end

    formatted = Enum.join(functions_and_aliases, "\n\n") |> Code.format_string!()

    IO.puts("""
    please add the following functions and aliases to your factory file:
    ```
    #{formatted}
    ```
    """)

    # output an empty list to match the other generators
    []
  end

  defp module_name_as_path(module_name) do
    module_name
    |> String.split(".")
    |> Enum.map(&Macro.underscore/1)
    |> Enum.join("/")
  end

  defp eval_from(source_file_path, binding) do
    content =
      (File.exists?(source_file_path) && File.read!(source_file_path)) ||
        raise "file #{source_file_path} does not exist"

    EEx.eval_string(content, binding)
  end

  def generate_timestamp do
    # Format the timestamp as YYYYMMDDHHMMSS
    next_timestamp()
    |> DateTime.to_naive()
    |> NaiveDateTime.to_iso8601()
    |> String.replace(~r/[-:T]/, "")
    |> String.slice(0..13)
  end

  defp next_timestamp do
    Agent.get_and_update(:timestamp_agent, fn timestamp ->
      {timestamp, DateTime.add(timestamp, 1, :second)}
    end)
  end
end
