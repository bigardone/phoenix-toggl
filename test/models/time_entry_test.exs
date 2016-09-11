defmodule PhoenixToggl.TimeEntryTest do
  use PhoenixToggl.ModelCase, async: true

  alias PhoenixToggl.TimeEntry

  setup do
    user = insert(:user)

    valid_attributes = %{
      name: "Default",
      user_id: user.id,
      started_at: Timex.now
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
    stopped_at = Timex.now
      |> Timex.add(Timex.Duration.from_minutes(2))

    time_entry = time_entry
      |> TimeEntry.stop(stopped_at)
      |> Repo.update!

    refute time_entry.stopped_at == nil
    assert time_entry.duration > 0
    assert time_entry.duration == Timex.diff(stopped_at, time_entry.started_at, :seconds)
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
    assert [restarted_at: { "can't be blank", []}] == changeset.errors
  end
end
