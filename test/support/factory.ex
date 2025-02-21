defmodule Test.Factory do
  use ExMachina.Ecto, repo: Core.Repo

  use Test.Factory.ActorFactory
end
