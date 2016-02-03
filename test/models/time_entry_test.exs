defmodule PhoenixToggl.TimeEntryTest do
  use PhoenixToggl.ModelCase

  alias PhoenixToggl.TimeEntry
  alias Timex.Date

  setup do
    workspace_user = create(:user)
      |> with_workspace
      |> Repo.preload(:workspaces)
      |> Map.get(:workspaces)
      |> List.last
      |> Repo.preload(:workspace_users)
      |> Map.get(:workspace_users)
      |> List.last

    valid_attributes = %{
      name: "Default",
      workspace_user_id: workspace_user.id,
      started_at: Date.now
    }

    {:ok, workspace_user: workspace_user, valid_attributes: valid_attributes}
  end

  test "changeset with valid attributes", %{valid_attributes: valid_attributes} do
    changeset = TimeEntry.changeset(%TimeEntry{}, valid_attributes)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = TimeEntry.changeset(%TimeEntry{}, %{})
    refute changeset.valid?
  end

  test "on insert it creates a new time_range", %{valid_attributes: valid_attributes} do
    changeset = TimeEntry.changeset(%TimeEntry{}, valid_attributes)

    Repo.insert! changeset
  end
end
