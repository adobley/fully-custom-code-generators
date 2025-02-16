[
  context: %{name: "Core.Quests", plural: "quests", singular: "quest"},
  live_view: %{
    actions: [:index, :show, :edit, :new, :delete],
    name: "Web.Live.Quests"
  },
  schemas: %{
    "Schema.Milestone" => %{
      generate_context_functions?: false,
      table: "milestones",
      fields: [
        %{
          name: "title",
          type: :string,
          required?: true
        },
        %{
          name: "description",
          type: :string
        },
        %{
          name: "status",
          type: :string,
          options: [:undiscovered, :discovered, :started, :finished],
          default: :undiscovered,
          required?: true
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
    },
    "Schema.Quest" => %{
      generate_context_functions?: true,
      table: "quests",
      singular: "quest",
      plural: "quests",
      fields: [
        %{
          name: "title",
          type: :string,
          required?: true
        },
        %{
          name: "description",
          type: :string
        },
        %{
          name: "status",
          type: :string,
          options: [:started, :unstarted, :finished],
          default: :unstarted,
          required?: true
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
