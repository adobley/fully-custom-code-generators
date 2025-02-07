[
  context: %{name: "Core.Quests", singular: "quest", plural: "quests"},
  live_view: %{
    actions: [:index, :show, :edit, :new, :delete],
    name: "Web.Live.Quests"
  },
  schemas: %{
    "Schema.Quest" => %{
      table: "quests",
      fields: [
        %{
          name: "title",
          type: :string
        },
        %{
          name: "description",
          type: :string
        },
        %{
          name: "status",
          type: :string,
          options: [:started, :unstarted, :finished],
          default: :unstarted
        },
        %{
          name: "start date",
          type: :date
        },
        %{
          name: "finish date",
          type: :date
        }
      ]
    }
  }
]
