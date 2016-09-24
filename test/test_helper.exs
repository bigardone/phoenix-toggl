{:ok, _} = Application.ensure_all_started(:ex_machina)

Application.ensure_all_started(:hound)

ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(PhoenixToggl.Repo, :manual)
