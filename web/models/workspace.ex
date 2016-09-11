defmodule PhoenixToggl.Workspace do
  use PhoenixToggl.Web, :model

  alias __MODULE__
  alias  PhoenixToggl.{User, WorkspaceUser, Repo}

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
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:user_id)
  end

  def insert_workspace_user(%Workspace{id: id, user_id: user_id}) do
     WorkspaceUser.changeset(%WorkspaceUser{}, %{workspace_id: id, user_id: user_id})
     |> Repo.insert!
  end
end
