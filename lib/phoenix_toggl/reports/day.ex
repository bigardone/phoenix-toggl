defmodule PhoenixToggl.Reports.Day do
  @moduledoc """
  Basic structure for a data day

    - date: Date inside the data range
    - duration: Sum of all time entries durations created that day
  """
  defstruct [
    date: nil,
    duration: 0
  ]
end
