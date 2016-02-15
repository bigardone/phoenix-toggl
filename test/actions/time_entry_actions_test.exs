defmodule PhoenixToggl.TimeEntryActionsTest do
  use PhoenixToggl.ModelCase, async: true

  alias PhoenixToggl.{TimeEntryActions, TimeEntry}
  alias Timex.Date

  setup do
    user = create(:user)

    valid_attributes = %{
      name: "Default",
      user_id: user.id,
      started_at: Date.now
    }

    {:ok, valid_attributes: valid_attributes}
  end

  test "start returns error when existing active TimeEntry", %{valid_attributes: valid_attributes} do
    %TimeEntry{}
      |> TimeEntry.start(valid_attributes)
      |> Repo.insert!

    assert TimeEntryActions.start(valid_attributes) == {:error, :active_time_entry_exists}
  end

  test "start", %{valid_attributes: valid_attributes} do
    time_entry = TimeEntryActions.start(valid_attributes)

    refute time_entry.started_at == nil
  end
end
