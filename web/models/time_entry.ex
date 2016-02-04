defmodule PhoenixToggl.TimeEntry do
  use PhoenixToggl.Web, :model
  use Ecto.Model.Callbacks

  alias PhoenixToggl.{TimeRange, Workspace, User}
  alias Timex.Ecto.DateTime
  alias Timex.Date

  schema "time_entries" do
    field :description, :string
    field :started_at, DateTime
    field :stopped_at, DateTime
    field :duration, :integer

    field :restarted_at, DateTime, virtual: true

    belongs_to :workspace, Workspace
    belongs_to :user, User

    embeds_many :ranges, TimeRange

    timestamps
  end

  @required_fields ~w(started_at workspace_id user_id)
  @optional_fields ~w(description stopped_at duration)
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
    |> set_time_range
  end

  @doc """
  Creates a default changeset and sets the stop key value
  on the last time_range
  """
  def stop_changeset(model, params \\ :empty) do
    model
    |> changeset(params)
    |> update_last_time_range
  end

  @doc """
  Creates a default changeset and sets the stop key value
  on the last time_range
  """
  def restart_changeset(model, params \\ :empty) do
    model
    |> changeset(params)
    |> cast(params, @restart_required_fields, @optional_fields)
    |> validate_previous_started_range
    |> start_new_time_range
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

  """
  def restart(time_entry, date_time \\ Date.now) do
    time_entry
    |> restart_changeset(%{restarted_at: date_time})
  end

  # Private functions
  ###################

  defp set_time_range(current_changeset) do
    time_range = %TimeRange{start: current_changeset.changes.started_at}
    put_embed(current_changeset, :ranges, [time_range])
  end

  defp update_last_time_range(current_changeset) do
    case current_changeset do
      %Ecto.Changeset{valid?: true, changes: %{stopped_at: stopped_at}, model: %{ranges: ranges, duration: total_duration}} ->
        index = length(ranges) - 1
        time_range = List.last(ranges)
        duration = Date.diff(time_range.start, stopped_at, :secs)

        time_range = %{time_range | stop: stopped_at, duration: duration}

        ranges = List.replace_at(ranges, index, time_range)

        current_changeset
        |> put_change(:duration, total_duration + duration)
        |> put_embed(:ranges, ranges)
      _ ->
        current_changeset
    end
  end

  defp start_new_time_range(current_changeset) do
    case current_changeset do
      %Ecto.Changeset{valid?: true, changes: %{restarted_at: restarted_at}} ->
        time_ranges = current_changeset.model.ranges ++ [%TimeRange{start: restarted_at}]

        current_changeset
        |> put_embed(:ranges, time_ranges)
      _ ->
        current_changeset
    end
  end

  def validate_previous_started_range(current_changeset) do
    range = List.last(current_changeset.model.ranges)

    validate_change current_changeset, :restarted_at, fn :restarted_at, _value ->
      if range.stop == nil, do: [{:restarted_at, "time range already started"}], else: []
    end
  end
end
