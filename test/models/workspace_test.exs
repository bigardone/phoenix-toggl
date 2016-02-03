defmodule PhoenixToggl.WorkspaceTest do
  use PhoenixToggl.ModelCase, async: true

  alias PhoenixToggl.Workspace

  setup do
    user = create(:user)

    {:ok, user: user}
  end

  test "changeset with valid attributes", %{user: user} do
    changeset = Workspace.changeset(%Workspace{}, %{name: "Deafult", user_id: user.id})
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Workspace.changeset(%Workspace{}, %{})
    refute changeset.valid?
  end

  test "creates automatically a workspace_user", %{user: user} do
    changeset = Workspace.changeset(%Workspace{}, %{name: "Deafult", user_id: user.id})

    {:ok, workspace} = Repo.insert changeset
    workspace = Repo.preload workspace, :users

    assert length(workspace.users) == 1

    workspace_user = List.first(workspace.users)

    assert workspace_user.id == user.id
  end
end
