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
