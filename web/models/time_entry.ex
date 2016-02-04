defmodule PhoenixToggl.TimeEntry do
  use PhoenixToggl.Web, :model
  use Ecto.Model.Callbacks

  alias __MODULE__
  alias PhoenixToggl.{TimeRange, Workspace, User}
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

  def stop_changeset(model, params \\ :empty) do
    model
    |> changeset(params)
    |> update_last_time_range
  end

  def stop(time_entry) do
    now = Date.now

    time_entry
    |> TimeEntry.stop_changeset(%{stopped_at: now})
  end

  defp set_time_range(current_changeset) do
    time_range = %TimeRange{start: current_changeset.changes.started_at}

    current_changeset = current_changeset
    |> Ecto.Changeset.put_embed(:ranges, [time_range])

    current_changeset
  end

  defp update_last_time_range(current_changeset) do
    case current_changeset do
      %Ecto.Changeset{valid?: true, changes: %{stopped_at: stopped_at}, model: %{ranges: ranges}} ->
        index = length(ranges) - 1

        time_range = ranges
          |> List.last
          |> Map.put(:stop, stopped_at)

        ranges = List.replace_at(ranges, index, time_range)

        Ecto.Changeset.put_embed(current_changeset, :ranges, ranges)
      _ ->
        current_changeset
    end
  end
end
