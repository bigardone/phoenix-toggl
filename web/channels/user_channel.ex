defmodule PhoenixToggl.UserChannel do
  use PhoenixToggl.Web, :channel

  alias PhoenixToggl.{TimerMonitor, TimeEntry}

  def join("users:" <> user_id, _params, socket) do
    user_id = String.to_integer(user_id)
    current_user = socket.assigns.current_user

    if user_id == current_user.id do
      {:ok, set_active_time_entry(socket, user_id)}
    else
      {:error, %{reason: "Invalid user"}}
    end
  end

  def handle_in("time_entry:start",
  %{
    "started_at" => started_at,
    "description" => description,
    "workspace_id" => workspace_id
  }, socket) do

    current_user = socket.assigns.current_user

    attributes = %{
      description: description,
      workspace_id: workspace_id,
      user_id: current_user.id,
      started_at: started_at
    }

    time_entry = %TimeEntry{}
      |> TimeEntry.start(attributes)
      |> Repo.insert!

    TimerMonitor.create(current_user.id)
    TimerMonitor.start(current_user.id, time_entry.id, time_entry.started_at)

    {:reply, {:ok, time_entry}, socket}
  end

  def handle_in("time_entry:stop",
  %{
    "id" => id,
    "stopped_at" => stopped_at,
  }, socket) do
    current_user = socket.assigns.current_user

    time_entry = current_user
    |> assoc(:time_entries)
    |> Repo.get!(id)
    |> TimeEntry.stop(stopped_at)
    |> Repo.update!

    TimerMonitor.stop(current_user.id)

    {:reply, {:ok, time_entry}, socket}
  end

  defp set_active_time_entry(socket, user_id) do
    case TimerMonitor.info(user_id) do
      %{time_entry_id: time_entry_id} ->
        time_entry = Repo.get! TimeEntry, time_entry_id

        assign(socket, :time_entry, %{id: time_entry_id})
      {:error, :invalid_timer} ->
        socket
    end
  end
end
