defmodule PhoenixToggl.WorkspaceMonitor do
  @moduledoc """
  Stores two maps:
  - One containing which user is in which workspace.
  - Another containing workspaces and their channel pid.
  """

  use GenServer

  # Client interface

  def create(workspace_id) do
    Supervisor.start_child(__MODULE__.Supervisor, [workspace_id])
  end

  def start_link(workspace_id) do
    case GenServer.whereis(ref(workspace_id)) do
      nil ->
        GenServer.start_link(__MODULE__, {[], %{}}, name: ref(workspace_id))
      _workspace ->
        {:error, :workspace_already_exists}
    end
  end

  @doc """
  Adds a user and his workspace.
  """
  def join(workspace_id, user_id) do
    case GenServer.whereis(ref(workspace_id)) do
      nil ->
        {:error, :invalid_workspace}
      workspace ->
        GenServer.call(workspace, {:join, user_id})
    end
  end

  def members(workspace_id) do
    case GenServer.whereis(ref(workspace_id)) do
      nil ->
        {:error, :invalid_workspace}
      workspace ->
        GenServer.call(workspace, :members)
    end
  end

  # Server interface

  def handle_call({:join, user_id}, _from, {users, timers}) do
    users = [user_id | users]

    {:reply, :ok, {users, timers}}
  end

  def handle_call(:members, _from, {users, _timers} = state) do
    {:reply, users, state}
  end

  defp ref(workspace_id) do
    {:global, {:workspace, workspace_id}}
  end
end
