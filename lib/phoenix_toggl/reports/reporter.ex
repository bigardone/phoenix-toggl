defmodule PhoenixToggl.Reports.Reporter do
  @moduledoc """
  Retrieves necessary data from the database
  """
  alias PhoenixToggl.{Repo, TimeEntry}
  alias PhoenixToggl.Reports.{Data, Day}
  alias Timex.{Date, Time, DateFormat}

  @format_string "{s-epoch}"

  def generate(), do: {:error, :invalid_params}
  def generate(%{user: _user} = params) do
    generate_data params
  end
  def generate(_), do: {:error, :invalid_params}

  defp generate_data(%{user: user}) do
    now = Date.now
    start_date = now |> Date.add(Time.to_timestamp(500, :days))
    end_date = Date.end_of_week(now, :mon)

    days = Date.diff(start_date, end_date, :days)

    days_data = 0..days
      |> Enum.map(fn(day) ->
        Task.async(fn -> calculate_day(user, start_date, day) end)
      end)
      |> Enum.map(&(Task.await(&1)))

    total_duration = calculate_total_duration(days_data)

    %Data{
      user_id: user.id,
      start_date: start_date |> DateFormat.format!("%Y-%m-%d", :strftime),
      end_date: end_date |> DateFormat.format!("%Y-%m-%d", :strftime),
      total_duration: total_duration,
      days: days_data
    }
  end

  defp calculate_day(user, start_date, day_number) do
    date = start_date
      |> Date.add(Time.to_timestamp(day_number, :days))
      |> DateFormat.format!("%Y-%m-%d", :strftime)

    total_duration = user
      |> Ecto.assoc(:time_entries)
      |> TimeEntry.total_duration_for_date(date)
      |> Repo.one!
      |> case do
        nil -> 0
        duration -> duration
      end

    IO.puts "Day #{day_number}"

    %Day{
      date: date,
      duration: total_duration
    }
  end

  defp calculate_total_duration(days_data), do: Enum.reduce(days_data, 0, fn(x, acc) -> x.duration + acc end)
end
