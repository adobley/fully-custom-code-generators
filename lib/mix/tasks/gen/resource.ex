defmodule Mix.Tasks.Gen.Resource do
  @shortdoc "context, liveview and appropriate tests for an existing table and table"
  @moduledoc false
  use Mix.Task

  alias Mix.Tasks.Format

  @impl Mix.Task
  def run([input_filename]) do
    {live_view_params_from_file, _binding = []} = Code.eval_file(input_filename)

    live_view_params =
      Keyword.put(
        live_view_params_from_file,
        :helper,
        Mix.Tasks.Gen.Resource.Helper
      )

    generators = [
      :generate_migrations,
      :generate_context,
      :generate_context_tests,
      :generate_live_index,
      :generate_live_show,
      :generate_live_view_tests
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

    output_filename = "tmp/bob/#{module_as_filename}.ex"

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

    output_filename = "tmp/bob/#{module_as_filename}_test.exs"

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

      output_filename = "tmp/bob/#{module_as_filename}.ex"

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

      output_filename = "tmp/bob/#{module_as_filename}.ex"

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

      output_filename = "tmp/bob/#{module_as_filename}.exs"

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

      schema_params =
        schema_data
        |> Map.put(:table, schema_data[:table])
        |> Map.put(:migration_helper, Mix.Tasks.Gen.Resource.Helper.Migration)
        |> Map.to_list()

      generated_file_contents =
        eval_from(
          "lib/mix/tasks/gen/resource/migration.exs",
          schema_params
        )

      output_filename = "priv/repo/migrations/#{file_name}.exs"

      Mix.Generator.create_file(output_filename, generated_file_contents, force: true)

      output_filename
    end
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
    # Get the current UTC time
    {:ok, datetime} = DateTime.now("Etc/UTC")

    # Format the timestamp as YYYYMMDDHHMMSS
    datetime
    |> DateTime.to_naive()
    |> NaiveDateTime.to_iso8601()
    |> String.replace(~r/[-:T]/, "")
    |> String.slice(0..13)
  end
end

defmodule TimestampGenerator do
  def generate_timestamp do
    # Get the current UTC time
    datetime =
      DateTime.utc_now()
      |> IO.inspect(label: " #{__ENV__.file}:#{__ENV__.line}")

    # Format the timestamp as YYYYMMDDHHMMSS
    datetime
    |> DateTime.to_naive()
    |> NaiveDateTime.to_iso8601()
    |> String.replace(~r/[-:T]/, "")
    |> String.slice(0..13)
  end
end
