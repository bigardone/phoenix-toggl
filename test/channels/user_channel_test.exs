defmodule PhoenixToggl.UserChannelTest do
  use PhoenixToggl.ChannelCase

  alias PhoenixToggl.{UserSocket, TimerMonitor, TimeEntry}

  setup do
    user = insert(:user)

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
    workspace = insert(:workspace, user_id: user.id)

    attributes = %{
      description: "Default",
      workspace_id: workspace.id,
      user_id: user.id,
      started_at: Timex.now
    }

    time_entry = %TimeEntry{}
      |> TimeEntry.start(attributes)
      |> Repo.insert!

    TimerMonitor.create(user.id)
    TimerMonitor.start(user.id, time_entry.id, Timex.now)

    {:ok, _, socket} = join(socket, "users:#{user.id}")

    assert time_entry.id == socket.assigns.time_entry.id
  end
end
