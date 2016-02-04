defmodule PhoenixToggl.TimerMonitor do
  @moduledoc """
  Stores the current active TimeEntry timer for a given user in a map
  containing the following information:

  - time_entry_id
  - started_at

  """

  use GenServer

  def create(user_id) do
    case GenServer.whereis(ref(user_id)) do
      nil ->
        Supervisor.start_child(__MODULE__.Supervisor, [user_id])
      _timer ->
        {:error, :timer_already_exists}
    end
  end

  def start_link(user_id) do
    GenServer.start_link(__MODULE__, %{time_entry_id: nil, start: nil}, name: ref(user_id))
  end

  def start(user_id, time_entry_id, started_at) do
    try_call(user_id, {:start, time_entry_id, started_at})
  end

  def handle_call({:start, _id, _started_at}, _from, %{time_entry_id: time_entry_id} = state) when time_entry_id != nil, do: {:reply, :timer_already_started, state}
  def handle_call({:start, id, started_at}, _from, _state) do
    new_state = %{
      time_entry_id: id,
      started_at: started_at
    }

    {:reply, new_state, new_state}
  end

  defp try_call(user_id, call_function) do
    case GenServer.whereis(ref(user_id)) do
      nil ->
        {:error, :invalid_timer}
      timer ->
        GenServer.call(timer, call_function)
    end
  end

  defp ref(user_id) do
    {:global, {:timer, user_id}}
  end
end
