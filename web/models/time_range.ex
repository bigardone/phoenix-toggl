defmodule PhoenixToggl.TimeRange do
  use Ecto.Schema

  alias Timex.Ecto.DateTime

  embedded_schema do
    field :start, DateTime
    field :stop, DateTime
    field :duration, :integer
  end
end
