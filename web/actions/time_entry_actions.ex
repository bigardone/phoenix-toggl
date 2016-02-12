defmodule PhoenixToggl.TimeEntryActions do
  alias PhoenixToggl.{Repo, TimeEntry}

  def start(%{user_id: user_id} = time_entry_params) do
    TimeEntry
    |> TimeEntry.active_for_user(user_id)
    |> Repo.one
    |> case  do
      nil ->
        perform_start(time_entry_params)
      _time_entry_params ->
        {:error, :active_time_entry_params_exists}
    end
  end

  defp perform_start(time_entry_params) do
    %TimeEntry{}
    |> TimeEntry.start(time_entry_params)
    |> Repo.insert!
  end
end
