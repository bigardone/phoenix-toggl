defmodule PhoenixToggl.TimeEntry do
  use PhoenixToggl.Web, :model
  use Ecto.Model.Callbacks

  alias PhoenixToggl.{Workspace, User}
  alias Timex.Ecto.DateTime
  alias Timex.Date

  @derive {Poison.Encoder, only: [:id, :description, :started_at, :stopped_at, :restarted_at, :duration, :updated_at]}

  schema "time_entries" do
    field :description, :string
    field :started_at, DateTime
    field :stopped_at, DateTime
    field :restarted_at, DateTime
    field :duration, :integer

    belongs_to :workspace, Workspace
    belongs_to :user, User

    timestamps
  end

  @required_fields ~w(started_at user_id)
  @optional_fields ~w(description stopped_at duration workspace_id restarted_at)

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
  Creates a default changeset and calculates the duration depending on
  if the TimeEntry has been restarted or not.
  """
  def stop_changeset(model, params \\ :empty) do
    duration = case model.restarted_at do
      nil ->
        Date.diff(model.started_at, params.stopped_at, :secs)
      restarted_at ->
        model.duration + Date.diff(restarted_at, params.stopped_at, :secs)
    end

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

  def active_for_user(query, user_id) do
    from t in query,
      where: t.user_id == ^user_id and is_nil(t.stopped_at)
  end

  def not_active_for_user(query, user_id) do
    from t in query,
      where: t.user_id == ^user_id and not(is_nil(t.stopped_at))
  end

  def sorted(query) do
    from t in query,
      order_by: [desc: t.updated_at]
  end

  def total_duration_for_date(query, date) do
    from t in query,
      select: sum(t.duration),
      where: fragment("date(?) = date(?)", t.started_at, type(^date, Ecto.Date))
  end

  # Private functions
  ###################

end
