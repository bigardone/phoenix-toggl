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

alias PhoenixToggl.{Repo, User, Workspace, TimeEntry, TimeEntryActions}
alias Timex.{Date, Time}

Repo.delete_all User

workspace = %User{}
|> User.changeset(%{first_name: "Ricardo", email: "bigardone@gmail.com", password: "12345678"})
|> Repo.insert!
|> Ecto.build_assoc(:owned_workspaces)
|> Workspace.changeset(%{name: "Default"})
|> Repo.insert!


number_of_days = 7

now = Date.now
start_date = now
  |> Date.subtract(Time.to_timestamp(number_of_days - 1, :days))


for day_number <- 0..(number_of_days - 1) do
  started_at =  start_date
    |> Date.add(Time.to_timestamp(day_number, :days))

  offset = Enum.random(120..480)

  stopped_at = started_at
    |> Date.add(Time.to_timestamp(offset, :mins))

  %{
    description: "Task #{day_number + 1}",
    user_id: workspace.user_id,
    started_at: started_at
  }
  |> TimeEntryActions.start
  |> TimeEntryActions.stop(stopped_at)
end
