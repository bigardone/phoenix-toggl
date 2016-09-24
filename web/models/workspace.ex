defmodule PhoenixToggl.Workspace do
  use PhoenixToggl.Web, :model

  alias  PhoenixToggl.{User, WorkspaceUser}

  @derive {Poison.Encoder, only: [:id, :name]}

  schema "workspaces" do
    field :name, :string

    belongs_to :owner, User, foreign_key: :user_id
    has_many :workspace_users, WorkspaceUser
    has_many :users, through: [:workspace_users, :user]

    timestamps
  end

  @required_fields ~w(name user_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:user_id)
    |> insert_workspace_user
  end

  defp insert_workspace_user(changeset) do
    workspace_user = %WorkspaceUser{user_id: get_field(changeset, :user_id)}
    put_assoc(changeset, :workspace_users, [workspace_user])
  end
end
