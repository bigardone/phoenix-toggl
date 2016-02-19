defmodule PhoenixToggl.Reports.Data do
  @moduledoc """
  Basic structure for report data

    - user_id: Owner id
    - start_date: Initial time from where to fetch time entries.
    - end_date: Finish time
    - total_duration: Sum of all days durations
    - days: List of durations per day between start_date and end_date
  """
  defstruct [
    user_id: nil,
    start_date: 0,
    end_date: 0,
    total_duration: 0,
    days: []
  ]
end
