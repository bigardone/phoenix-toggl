defmodule PhoenixToggl.TimeEntryTest do
  use PhoenixToggl.ModelCase, async: true

  alias PhoenixToggl.TimeEntry
  alias Timex.Date

  setup do
    user = create(:user)

    valid_attributes = %{
      name: "Default",
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

  test "stop", %{time_entry: time_entry} do
    stopped_at = Date.now
      |> Date.shift(mins: 2)

    time_entry = time_entry
      |> TimeEntry.stop(stopped_at)
      |> Repo.update!

    refute time_entry.stopped_at == nil
    assert time_entry.duration > 0
    assert time_entry.duration == Date.diff(time_entry.started_at, stopped_at, :secs)
  end

  test "restart", %{time_entry: time_entry} do
    time_entry = time_entry
    |> TimeEntry.stop
    |> Repo.update!
    |> TimeEntry.restart
    |> Repo.update!

    refute time_entry.restarted_at == nil
    assert time_entry.stopped_at == nil
  end

  test "restart with no restart_at", %{time_entry: time_entry} do
    changeset = TimeEntry.restart_changeset(time_entry, %{})

    refute changeset.valid?
    assert {:restarted_at, "can't be blank"} in changeset.errors
  end
end
