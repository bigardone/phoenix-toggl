defmodule PhoenixToggl.TimeEntryController do
  use PhoenixToggl.Web, :controller

  alias PhoenixToggl.{Repo, TimeEntry}

  plug Guardian.Plug.EnsureAuthenticated, handler: PhoenixTrello.SessionController

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    time_entries = current_user
      |> assoc(:time_entries)
      |> TimeEntry.not_active_for_user(current_user.id)
      |> TimeEntry.sorted
      |> Repo.all

    json conn, %{time_entries: time_entries}
  end
end
