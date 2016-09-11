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

alias PhoenixToggl.{Repo, User, Workspace, TimeEntryActions}

Repo.delete_all User

alias Ecto.Multi

Multi.new
|> Multi.insert(:user, User.changeset(%User{}, %{first_name: "Mario", email: "foo@bar.com", password: "123456"}))



workspace = %User{}
|> User.changeset(%{first_name: "Ricardo", email: "bigardone@gmail.com", password: "12345678"})
|> Repo.insert!
|> Ecto.build_assoc(:owned_workspaces)
|> Workspace.changeset(%{name: "Default"})
|> Repo.insert!


number_of_days = 7

now = Timex.now
start_date = now
  |> Timex.subtract(Timex.Duration.from_days(number_of_days - 1))


for day_number <- 0..(number_of_days - 1) do
  started_at =  start_date
    |> Timex.add(Timex.Duration.from_days(day_number))

  offset = Enum.random(120..480)

  stopped_at = started_at
    |> Timex.add(Timex.Duration.from_minutes(offset))

  %{
    description: "Task #{day_number + 1}",
    user_id: workspace.user_id,
    started_at: started_at
  }
  |> TimeEntryActions.start
  |> TimeEntryActions.stop(stopped_at)
end
