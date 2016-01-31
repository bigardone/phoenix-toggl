ExUnit.start

Mix.Task.run "ecto.create", ~w(-r PhoenixToggl.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r PhoenixToggl.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(PhoenixToggl.Repo)

