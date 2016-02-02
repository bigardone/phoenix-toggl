defmodule PhoenixToggl.WorkspaceChannel do
  use PhoenixToggl.Web, :channel

  alias PhoenixToggl.Lobby

  def join("workspaces:" <> workspace_id, _payload, socket) do
    current_user = socket.assigns.current_user

    workspace = current_user
      |> assoc(:workspaces)
      |> Repo.get(workspace_id)

    # TODO find workspace server from the Lobby and add add user to connected users.
    Lobby.join(current_user.id, workspace_id, self)
    send self, {:after_join, []}

    {:ok, %{workspace: workspace}, assign(socket, :workspace, workspace)}
  end

  def handle_info({:after_join, users}, socket) do
    broadcast! socket, "user:joined", %{users: users}

    {:noreply, socket}
  end
end
