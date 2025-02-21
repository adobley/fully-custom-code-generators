defmodule Test.Factory.ActorFactory do
  defmacro __using__(_opts) do
    quote do
      def npc_factory(attrs) do
        %{
          name: Faker.String.base64()
        }
        |> merge_attributes(attrs)
        |> evaluate_lazy_attributes()
      end
    end
  end
end
