defmodule PhoenixToggl.TimeEntryTest do
  use PhoenixToggl.ModelCase

  alias PhoenixToggl.TimeEntry
  alias Timex.Date

  setup do
    user = create(:user)
      |> with_workspace
      |> Repo.preload(:workspaces)

    workspace = List.last(user.workspaces)

    valid_attributes = %{
      name: "Default",
      workspace_id: workspace.id,
      user_id: user.id,
      started_at: Date.now
    }

    {:ok, valid_attributes: valid_attributes}
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
