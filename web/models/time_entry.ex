defmodule PhoenixToggl.TimeEntry do
  use PhoenixToggl.Web, :model

  alias PhoenixToggl.{TimeRange, WorkspaceUser}
  alias Timex.Ecto.DateTime

  schema "time_entries" do
    field :description, :string
    field :started_at, DateTime
    field :stopped_at, DateTime
    field :duration, :integer

    belongs_to :workspace_user, WorkspaceUser
    embeds_many :ranges, TimeRange

    timestamps
  end

  @required_fields ~w(started_at workspace_user_id)
  @optional_fields ~w(description stopped_at duration)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
