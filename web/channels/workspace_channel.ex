defmodule PhoenixToggl.WorkspaceChannel do
  use PhoenixToggl.Web, :channel

  alias PhoenixToggl.{WorkspaceMonitor}

  def join("workspaces:" <> workspace_id, _payload, socket) do
    current_user = socket.assigns.current_user

    current_user
      |> Repo.preload(:owned_workspaces)
      |> assoc(:owned_workspaces)
      |> Repo.get(workspace_id)
      |> case do
          nil ->
            {:error, %{}}
          workspace ->
            WorkspaceMonitor.create(workspace.id)
            WorkspaceMonitor.join(workspace.id, current_user.id)

            socket = assign(socket, :workspace, workspace)
            {:ok, socket}
         end
  end

  def terminate(_reason, socket) do
    workspace_id = socket.assigns.workspace.id
    user_id = socket.assigns.current_user.id

    WorkspaceMonitor.leave(workspace_id, user_id)

    :ok
  end
end
