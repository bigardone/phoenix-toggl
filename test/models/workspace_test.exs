defmodule PhoenixToggl.WorkspaceTest do
  use PhoenixToggl.ModelCase

  alias PhoenixToggl.Workspace

  @valid_attrs %{name: "some content", user_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Workspace.changeset(%Workspace{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Workspace.changeset(%Workspace{}, @invalid_attrs)
    refute changeset.valid?
  end
end
