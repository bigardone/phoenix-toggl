defmodule PhoenixToggl.WorkspaceUser do
  use PhoenixToggl.Web, :model

  alias __MODULE__

  schema "workspace_users" do
    belongs_to :workspace, PhoenixToggl.Workspace
    belongs_to :user, PhoenixToggl.User

    timestamps
  end

  @required_fields ~w(user_id workspace_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def find_by_workspace_and_user(query \\ %WorkspaceUser{}, workspace_id, user_id) do
    from u in query,
    where: u.user_id == ^user_id and u.workspace_id == ^workspace_id
  end
end
