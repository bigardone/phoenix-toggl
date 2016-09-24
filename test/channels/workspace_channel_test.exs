defmodule PhoenixToggl.WorkspaceChannelTest do
  use PhoenixToggl.ChannelCase

  alias PhoenixToggl.{UserSocket, WorkspaceMonitor}

  setup do
    user = insert(:user)
    workspace = insert(:workspace, user_id: user.id)

    {:ok, jwt, _full_claims} = user |> Guardian.encode_and_sign(:token)

    {:ok, socket} = connect(UserSocket, %{"token" => jwt})

    {:ok, socket: socket, user: user, workspace: workspace}
  end

  test "fails to join invalid workspace", %{socket: socket} do
    assert {:error, _} = join(socket, "workspaces:9999999")
  end

  test "after joining", %{socket: socket, user: user, workspace: workspace} do
    {:ok, _, socket} = join(socket, "workspaces:#{workspace.id}")

    assert socket.assigns[:workspace] == workspace
    assert Enum.member?(WorkspaceMonitor.members(workspace.id), user.id)
  end

  test "when leaving the channel", %{socket: socket, user: user, workspace: workspace} do
    {:ok, _, socket} = join(socket, "workspaces:#{workspace.id}")
    WorkspaceMonitor.join(workspace.id, 1234)

    assert Enum.member?(WorkspaceMonitor.members(workspace.id), user.id)

    Process.unlink(socket.channel_pid)
    ref = leave(socket)

    assert_reply ref, :ok

    refute Enum.member?(WorkspaceMonitor.members(workspace.id), user.id)
  end
end
