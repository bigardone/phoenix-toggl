defmodule PhoenixToggl.TimeEntry do
  use PhoenixToggl.Web, :model
  use Ecto.Model.Callbacks

  alias __MODULE__
  alias PhoenixToggl.{TimeRange, Workspace, User, Repo}
  alias Timex.Ecto.DateTime
  alias Timex.Date

  schema "time_entries" do
    field :description, :string
    field :started_at, DateTime
    field :stopped_at, DateTime
    field :duration, :integer

    belongs_to :workspace, Workspace
    belongs_to :user, User

    embeds_many :ranges, TimeRange

    timestamps
  end

  @required_fields ~w(started_at workspace_id user_id)
  @optional_fields ~w(description stopped_at duration)

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

  @doc """
  Also sets the first time_range
  """
  def insert_changeset(model, params \\ :empty) do
    model
    |> changeset(params)
    |> set_time_range
  end

  def stop(time_entry) do
    now = Date.now

    # TODO update last time_range

    time_entry
    |> TimeEntry.changeset(%{stopped_at: now})
    |> Repo.update!
  end

  defp set_time_range(changeset) do
    time_range = %TimeRange{start: changeset.changes.started_at}

    changeset = changeset
    |> Ecto.Changeset.put_embed(:ranges, [time_range])

    changeset
  end
end
