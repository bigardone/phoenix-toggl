defmodule PhoenixToggl.LobbyMonitor do
  @moduledoc """
  Stores two maps:
  - One containing which user is in which workspace.
  - Another containing workspaces and their channel pid.
  """

  use GenServer

  # Client interface

  def start_link do
    GenServer.start_link(__MODULE__, {%{}, %{}}, name: __MODULE__)
  end

  @doc """
  Adds a user and his workspace, and the workspace and its channel pid.
  """
  def join(user_id, workspace_id, channel_pid) do
    GenServer.call(__MODULE__, {:join, user_id, workspace_id, channel_pid})
  end

  @doc """
  Removes a user with the user_id
  """
  def leave(user_id) do
    GenServer.call(__MODULE__, {:leave, user_id})
  end

  @doc """
  Returns all users connected
  """
  def users do
    GenServer.call(__MODULE__, :users)
  end

  @doc """
  Gets a user by the given user_id
  """
  def find_user(user_id) do
    GenServer.call(__MODULE__, {:find_user, user_id})
  end

  @doc """
  Gets a channel_pid by the given workspace_pid
  """
  def find_workspace(workspace_id) do
    GenServer.call(__MODULE__, {:find_workspace, workspace_id})
  end

  # Server interface

  def handle_call({:join, user_id, workspace_id, channel_pid}, _from, {users, workspaces}) do
    Process.monitor(channel_pid)

    users = Map.put(users, user_id, workspace_id)
    workspaces = Map.put(workspaces, workspace_id, channel_pid)

    {:reply, :ok, {users, workspaces}}
  end

  def handle_call({:leave, user_id}, _from, {users, workspaces}) do
    workspace_id = Map.get(users, user_id)
    users = Map.delete(users, user_id)
    workspaces = Map.delete(workspaces, workspace_id)

    {:reply, :ok, {users, workspaces}}
  end

  def handle_call(:users, _from, {users, _workspaces} = state) do
    ids = Map.keys(users)
    {:reply, ids, state}
  end

  def handle_call({:find_user, user_id}, _from, {users, _workspaces} = state) do
    {:reply, Map.get(users, user_id), state}
  end

  def handle_call({:find_workspace, workspace_id}, _from, {_users, workspaces} = state) do
    {:reply, Map.get(workspaces, workspace_id), state}
  end
end
