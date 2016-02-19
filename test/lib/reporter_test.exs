defmodule PhoenixToggl.RepoterTest do
  use PhoenixToggl.ModelCase, async: true

  alias PhoenixToggl.Reports.Reporter
  alias PhoenixToggl.{TimeEntryActions}
  alias Timex.{Date, Time}

  setup do
    user = create(:user)

    from_date = Date.now |> Date.subtract(Time.to_timestamp(5, :days))
    to_date = Date.now

    for day_number <- 0..5 do
      started_at =  from_date
        |> Date.add(Time.to_timestamp(day_number, :days))

      stopped_at = started_at
        |> Date.add(Time.to_timestamp(4, :hours))

      %{
        name: "Default",
        user_id: user.id,
        started_at: started_at
      }
      |> TimeEntryActions.start
      |> TimeEntryActions.stop(stopped_at)
    end

    {:ok, user: user, from_date: from_date, to_date: to_date}
  end

  test "invalid params" do
    assert Reporter.generate(%{}) == {:error, :invalid_params}
    assert Reporter.generate() == {:error, :invalid_params}
  end

  test "valid params", %{user: _user, from_date: _from_date, to_date: _to_date} = params do
    IO.inspect :timer.tc(fn -> Reporter.generate(params) end)
  end
end
