defmodule PhoenixToggl.TimeEntryActions do
  alias PhoenixToggl.{Repo, TimeEntry}

  @doc """
  Returns the active TimeEntry for a user from the database
  """
  def get_active_for_user(user_id) do
    TimeEntry
    |> TimeEntry.active_for_user(user_id)
    |> Repo.one
  end

  @doc """
  Creates a new TimeEntry
  """
  def start(%{user_id: user_id} = time_entry_params) do
    case get_active_for_user(user_id) do
      nil ->
        perform_start(time_entry_params)
      _time_entry_params ->
        {:error, :active_time_entry_exists}
    end
  end

  def stop(time_entry, stopped_at) do
    time_entry
    |> TimeEntry.stop(stopped_at)
    |> Repo.update!
  end

  def restart(time_entry, restarted_at) do
    case get_active_for_user(time_entry.user_id) do
      nil ->
        perform_restart(time_entry, restarted_at)
      _time_entry_params ->
        {:error, :active_time_entry_exists}
    end
  end

  def update(time_entry, params) do
    time_entry
    |> TimeEntry.changeset(params)
    |> Repo.update!
  end

  def discard(time_entry) do
    time_entry
    |> Repo.delete!
  end

  defp perform_start(time_entry_params) do
    %TimeEntry{}
    |> TimeEntry.start(time_entry_params)
    |> Repo.insert!
  end

  defp perform_restart(time_entry, restarted_at) do
    time_entry
    |> TimeEntry.restart(restarted_at)
    |> Repo.update!
  end
end
