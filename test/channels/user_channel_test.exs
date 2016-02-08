defmodule PhoenixToggl.UserChannelTest do
  use PhoenixToggl.ChannelCase, async: true

  alias PhoenixToggl.{UserSocket, TimerMonitor, TimeEntry}
  alias Timex.Date

  setup do
    user = create(:user)

    {:ok, jwt, _full_claims} = user |> Guardian.encode_and_sign(:token)
    {:ok, socket} = connect(UserSocket, %{"token" => jwt})

    {:ok, socket: socket, user: user}
  end

  test "fails to join for an invalid user", %{socket: socket} do
    assert {:error, _} = join(socket, "users:99999999")
  end

  test "after joining with no active timer", %{socket: socket, user: user} do
    {:ok, _, socket} = join(socket, "users:#{user.id}")

    refute Enum.member?(socket.assigns, :time_entry)
  end

  test "after joining with active timer", %{socket: socket, user: user} do
    workspace = create(:workspace, user_id: user.id)

    attributes = %{
      description: "Default",
      workspace_id: workspace.id,
      user_id: user.id,
      started_at: Date.now
    }

    time_entry = %TimeEntry{}
      |> TimeEntry.start(attributes)
      |> Repo.insert!

    TimerMonitor.create(user.id)
    TimerMonitor.start(user.id, time_entry.id, Date.now)

    {:ok, _, socket} = join(socket, "users:#{user.id}")

    assert time_entry.id == socket.assigns.time_entry.id
  end
end
