defmodule PhoenixToggl.WorkspaceUser do
  use PhoenixToggl.Web, :model

  alias __MODULE__
  alias  PhoenixToggl.{Workspace, User}

  schema "workspace_users" do
    belongs_to :workspace, Workspace
    belongs_to :user, User

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
    |> foreign_key_constraint(:workspace_id)
    |> foreign_key_constraint(:user_id)
  end

  def find_by_workspace_and_user(query \\ %WorkspaceUser{}, workspace_id, user_id) do
    from u in query,
    where: u.user_id == ^user_id and u.workspace_id == ^workspace_id
  end
end
