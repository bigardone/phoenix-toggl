defmodule PhoenixToggl.TimeEntryTest do
  use PhoenixToggl.ModelCase, async: true

  alias PhoenixToggl.TimeEntry
  alias Timex.Date

  setup do
    user = create(:user)
    workspace = create(:workspace, user_id: user.id)
    valid_attributes = %{
      name: "Default",
      workspace_id: workspace.id,
      user_id: user.id,
      started_at: Date.now
    }

    time_entry = %TimeEntry{}
      |> TimeEntry.insert_changeset(valid_attributes)
      |> Repo.insert!

    {:ok, valid_attributes: valid_attributes, time_entry: time_entry}
  end

  test "changeset with valid attributes", %{valid_attributes: valid_attributes} do
    changeset = TimeEntry.changeset(%TimeEntry{}, valid_attributes)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = TimeEntry.changeset(%TimeEntry{}, %{})
    refute changeset.valid?
  end

  test "on insert it creates a new time_range", %{time_entry: time_entry} do
    assert length(time_entry.ranges) == 1
  end

  test "stop", %{time_entry: time_entry} do
    time_entry = TimeEntry.stop(time_entry)

    refute time_entry.stopped_at == nil
  end
end
