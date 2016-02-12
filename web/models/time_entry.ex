defmodule PhoenixToggl.TimeEntry do
  use PhoenixToggl.Web, :model
  use Ecto.Model.Callbacks

  alias PhoenixToggl.{Workspace, User}
  alias Timex.Ecto.DateTime
  alias Timex.Date

  @derive {Poison.Encoder, only: [:id, :description, :started_at, :stopped_at, :duration]}

  schema "time_entries" do
    field :description, :string
    field :started_at, DateTime
    field :stopped_at, DateTime
    field :duration, :integer

    field :restarted_at, DateTime, virtual: true

    belongs_to :workspace, Workspace
    belongs_to :user, User

    timestamps
  end

  @required_fields ~w(started_at user_id)
  @optional_fields ~w(description stopped_at duration workspace_id)
  @restart_required_fields ~w(restarted_at)

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
  Creates a default changeset and sets the first time_range
  """
  def start_changeset(model, params \\ :empty) do
    model
    |> changeset(params)
    |> put_change(:duration, 0)
  end

  @doc """
  Creates a default changeset and sets the stop key value
  on the last time_range
  """
  def stop_changeset(model, params \\ :empty) do
    duration = Date.diff(model.started_at, params.stopped_at, :secs)

    model
    |> changeset(params)
    |> put_change(:duration, duration)
  end

  @doc """
  Creates a default changeset and sets the stop key value
  on the last time_range
  """
  def restart_changeset(model, params \\ :empty) do
    model
    |> changeset(params)
    |> cast(params, @restart_required_fields, @optional_fields)
    |> put_change(:stopped_at, nil)
  end

  @doc """
  Returns a start_changeset
  """
  def start(time_entry, params) do
    time_entry
    |> start_changeset(params)
  end

  @doc """
  Returns a stop_changeset
  """
  def stop(time_entry, date_time \\ Date.now) do
    time_entry
    |> stop_changeset(%{stopped_at: date_time})
  end

  @doc """
  Returns a restart_changeset
  """
  def restart(time_entry, date_time \\ Date.now) do
    time_entry
    |> restart_changeset(%{restarted_at: date_time})
  end

  # Private functions
  ###################

end
