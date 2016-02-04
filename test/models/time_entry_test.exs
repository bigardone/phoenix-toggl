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
      |> TimeEntry.start(valid_attributes)
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
    time_entry = time_entry
      |> TimeEntry.stop
      |> Repo.update!

    refute time_entry.stopped_at == nil

    time_range = List.last(time_entry.ranges)

    assert time_range.stop == time_entry.stopped_at
    assert time_range.duration == Date.diff(time_range.start, time_range.stop, :secs)
  end

  test "restart", %{time_entry: time_entry} do
    time_entry = time_entry
    |> TimeEntry.stop
    |> Repo.update!
    |> TimeEntry.restart
    |> Repo.update!

    time_range = List.last(time_entry.ranges)

    assert length(time_entry.ranges) == 2
    assert time_range.stop == nil
  end

  test "restart with no restart_at", %{time_entry: time_entry} do
    changeset = TimeEntry.restart_changeset(time_entry, %{})

    refute changeset.valid?
    assert {:restarted_at, "can't be blank"} in changeset.errors
  end

  test "restart when there is a current time_period started", %{time_entry: time_entry} do
    changeset = TimeEntry.restart(time_entry)

    refute changeset.valid?
    assert {:restarted_at, "time range already started"} in changeset.errors
  end
end
