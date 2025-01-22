defmodule Core.Repo do
  use Ecto.Repo,
    otp_app: :arcane_assist,
    adapter: Ecto.Adapters.Postgres
end
