defmodule PhoenixToggl.WorkspaceMonitorTest do
  use ExUnit.Case

  alias PhoenixToggl.WorkspaceMonitor

  setup do
    :ok
  end

  test "creating same workspace twice returns error" do
    WorkspaceMonitor.create(1)
    assert WorkspaceMonitor.create(1) == {:error, :workspace_already_exists}
  end

  test "user joins a correct workspace" do
    user_id = 1

    WorkspaceMonitor.create(1)

    assert WorkspaceMonitor.join(1, user_id) == :ok
    assert Enum.member?(WorkspaceMonitor.members(1), user_id)
  end

  test "user joins a incorrect workspace" do
    user_id = 1

    assert WorkspaceMonitor.join(2, user_id) == {:error, :invalid_workspace}
  end

  test "all users" do

  end
end
