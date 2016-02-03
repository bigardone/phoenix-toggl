defmodule PhoenixToggl.WorkspaceMonitorTest do
  use ExUnit.Case, async: true

  alias PhoenixToggl.WorkspaceMonitor

  setup do
    workspace_id = :crypto.strong_rand_bytes(32) |> Base.encode64()
    {:ok, pid} = WorkspaceMonitor.create(workspace_id)

    {:ok, workspace_id: workspace_id, pid: pid}
  end

  test "creating same workspace twice returns error", %{workspace_id: workspace_id}  do
    assert WorkspaceMonitor.create(workspace_id) == {:error, :workspace_already_exists}
  end

  test "user joins a correct workspace", %{workspace_id: workspace_id}  do
    user_id = 1

    assert WorkspaceMonitor.join(workspace_id, user_id) == :ok
    assert Enum.member?(WorkspaceMonitor.members(workspace_id), user_id)
  end

  test "user joins a incorrect workspace" do
    user_id = 1

    assert WorkspaceMonitor.join(3333, user_id) == {:error, :invalid_workspace}
  end

  test "all members", %{workspace_id: workspace_id}  do
    users = [1, 2, 3, 4, 5]
    Enum.each(users, &WorkspaceMonitor.join(workspace_id, &1))

    assert WorkspaceMonitor.members(workspace_id) == Enum.reverse(users)
  end

  test "user leaves the workspace", %{workspace_id: workspace_id} do
    users = [1, 2, 3, 4, 5]
    Enum.each(users, &WorkspaceMonitor.join(workspace_id, &1))

    WorkspaceMonitor.leave(workspace_id, 1)

    assert WorkspaceMonitor.members(workspace_id) == users |> List.delete(1) |> Enum.reverse
  end

  test "last user leaves", %{workspace_id: workspace_id} do
    WorkspaceMonitor.join(workspace_id, 1)
    WorkspaceMonitor.leave(workspace_id, 1)

    assert WorkspaceMonitor.members(workspace_id) == {:error, :invalid_workspace}
  end
end
