defmodule Mix.Tasks.Gen.Resource.Helper do
  defmodule Migration do
    def types(fields) do
      for field <- fields do
        dbg()
        "add :#{underscore(field.name)}, #{migration_type(field.type)}"
      end
      |> Enum.join("\n")
    end

    defp migration_type(type) do
      ":" <> type
    end

    defp underscore(string) do
      string
      |> Macro.underscore()
      |> String.replace(" ", "_")
    end
  end
end
