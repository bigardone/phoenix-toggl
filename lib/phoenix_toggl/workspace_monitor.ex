defmodule PhoenixToggl.WorkspaceMonitor do
  @moduledoc """
  Stores two maps:
  - One containing which user is in which workspace.
  - Another containing workspaces and their channel pid.
  """
  use GenServer

  # Client interface

  @doc """
  This will force the PhoenixToggl.WorkspaceMonitor.Supervisor to start
  a new child if it not already exists
  """
  def create(workspace_id) do
    case GenServer.whereis(ref(workspace_id)) do
      nil ->
        Supervisor.start_child(__MODULE__.Supervisor, [workspace_id])
      _workspace ->
        {:error, :workspace_already_exists}
    end
  end

  def start_link(workspace_id) do
    GenServer.start_link(__MODULE__, [], name: ref(workspace_id))
  end

  @doc """
  Adds a user to the workspace.
  """
  def join(workspace_id, user_id) do
    try_call workspace_id, {:join, user_id}
  end

  @doc """
  Returns back all connected users in a workspace
  """
  def members(workspace_id) do
    try_call workspace_id, :members
  end

  @doc """
  Removes a user from a workspace
  """
  def leave(workspace_id, user_id) do
    try_call workspace_id, {:leave, user_id}
  end

  # Server interface

  def handle_call({:join, user_id}, _from, users) do
    users = [user_id] ++ users

    {:reply, :ok, users}
  end

  def handle_call(:members, _from, users) do
    {:reply, users, users}
  end

  def handle_call({:leave, user_id}, _from, users) do
    users = List.delete(users, user_id)

    case length(users) do
      0 -> {:stop, :normal, :ok, users} 
      _ -> {:reply, users, users}
    end
  end

  defp ref(workspace_id) do
    {:global, {:workspace, workspace_id}}
  end

  defp try_call(workspace_id, call_function) do
    case GenServer.whereis(ref(workspace_id)) do
      nil ->
        {:error, :invalid_workspace}
      workspace ->
        GenServer.call(workspace, call_function)
    end
  end
end
