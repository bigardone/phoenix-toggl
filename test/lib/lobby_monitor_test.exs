defmodule PhoenixToggl.LobbyMonitorTest do
  use ExUnit.Case

  alias PhoenixToggl.LobbyMonitor

  setup do
    on_exit fn ->
      Enum.each(LobbyMonitor.users, &LobbyMonitor.leave/1)
    end

    :ok
  end

  test "user joins the lobby" do
    user_id = 1
    workspace_id = 1
    channel_id = test_pid

    assert LobbyMonitor.join(user_id, workspace_id, channel_id) == :ok
  end

  test "user leaves the lobby" do
    LobbyMonitor.join 1, 1, test_pid
    LobbyMonitor.join 2, 2, test_pid

    assert LobbyMonitor.leave(1) == :ok
    refute LobbyMonitor.find_user(1)
  end

  test "all users" do
    LobbyMonitor.join 1, 1, test_pid
    LobbyMonitor.join 2, 2, test_pid

    assert LobbyMonitor.users == [1, 2]
  end

  test "returns a workspace channel pid" do
    workspace_pid = test_pid
    LobbyMonitor.join 1, 1, workspace_pid
    LobbyMonitor.join 2, 2, test_pid

    assert LobbyMonitor.find_workspace(1) == workspace_pid
  end

  defp test_pid do
    spawn fn ->
      receive do
      end
    end
  end
end
