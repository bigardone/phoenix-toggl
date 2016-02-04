defmodule PhoenixToggl.TimerMonitorTest do
  use ExUnit.Case, async: true

  alias PhoenixToggl.TimerMonitor
  alias Timex.Date

  setup do
    user_id = :crypto.strong_rand_bytes(32) |> Base.encode64()
    {:ok, pid} = TimerMonitor.create(user_id)

    {:ok, user_id: user_id, pid: pid}
  end

  test "creting same timer twice returns error", %{user_id: user_id} do
    assert TimerMonitor.create(user_id) == {:error, :timer_already_exists}
  end

  test "starting a new timer", %{user_id: user_id} do
    time_entry_id = 1
    started_at = Date.now
    assert TimerMonitor.start(user_id, time_entry_id, started_at) == %{time_entry_id: time_entry_id, started_at: started_at}
  end

  test "starting a new timer more times", %{user_id: user_id} do
    time_entry_id = 1
    started_at = Date.now
    TimerMonitor.start(user_id, time_entry_id, started_at)
    assert TimerMonitor.start(user_id, time_entry_id, started_at) == :timer_already_started
  end
end
