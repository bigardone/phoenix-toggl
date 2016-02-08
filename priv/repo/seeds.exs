# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PhoenixToggl.Repo.insert!(%PhoenixToggl.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PhoenixToggl.{Repo, User, Workspace, TimeEntry}
alias Timex.Date

workspace = %User{}
|> User.changeset(%{first_name: "Ricardo", email: "ricardo@email.com", password: "12345678"})
|> Repo.insert!
|> Ecto.build_assoc(:owned_workspaces)
|> Workspace.changeset(%{name: "Default"})
|> Repo.insert!


%TimeEntry{}
|> TimeEntry.start(%{
  user_id: workspace.user_id,
  workspace_id: workspace.id,
  description: "Test",
  started_at: Date.now
})
|> Repo.insert!
