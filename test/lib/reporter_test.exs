defmodule PhoenixToggl.RepoterTest do
  use PhoenixToggl.ModelCase

  alias PhoenixToggl.Reports.{Reporter}
  alias PhoenixToggl.{TimeEntryActions}

  setup do
    user = insert(:user)
    number_of_weeks = 2

    now = Timex.now
    start_date = now
      |> Timex.subtract(Timex.Duration.from_weeks(number_of_weeks - 1))
      |> Timex.beginning_of_week(:mon)
    end_date = Timex.end_of_week(now, :mon)

    for day_number <- 0..((number_of_weeks * 7) - 1) do
      started_at =  start_date
        |> Timex.add(Timex.Duration.from_days(day_number))

      stopped_at = started_at
        |> Timex.add(Timex.Duration.from_hours(4))

      %{
        name: "Default",
        user_id: user.id,
        started_at: started_at
      }
      |> TimeEntryActions.start
      |> TimeEntryActions.stop(stopped_at)
    end

    {:ok, user: user, start_date: start_date, end_date: end_date, number_of_weeks: number_of_weeks}
  end

  test "invalid params" do
    assert Reporter.generate(%{}) == {:error, :invalid_params}
    assert Reporter.generate() == {:error, :invalid_params}
  end

  test "valid params", %{user: user, start_date: start_date, end_date: end_date, number_of_weeks: number_of_weeks} = params do
    data = Reporter.generate(params)

    assert data.user_id == user.id
    assert data.start_date == start_date |> Timex.format!("%Y-%m-%d", :strftime)
    assert data.end_date == end_date |> Timex.format!("%Y-%m-%d", :strftime)
    assert length(data.days) == 7 * number_of_weeks

    for day <- data.days  do
      assert day.duration == 4 * 3600
    end

    assert data.total_duration == 7 * 4 * 3600 * number_of_weeks
  end
end
