[
  context: %{name: "Core.Quests", singular: "quest", plural: "quests"},
  live_view: %{
    actions: [:index, :show, :edit, :new, :delete],
    name: "Web.Live.Quests"
  },
  schemas: %{
    "Core.Schema.Quest" => %{
      table: "quests",
      fields: [
        %{
          name: "title",
          type: "string"
        },
        %{
          name: "description",
          type: "string"
        },
        %{
          name: "status",
          type: "string",
          options: ["active", "inactive"],
          default: "active"
        },
        %{
          name: "start time",
          type: "date"
        },
        %{
          name: "finish time",
          type: "date"
        }
      ]
    }
  }
]
