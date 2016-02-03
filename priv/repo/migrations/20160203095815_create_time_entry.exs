defmodule PhoenixToggl.Repo.Migrations.CreateTimeEntry do
  use Ecto.Migration

  def change do
    create table(:time_entries) do
      add :description, :text
      add :started_at, :datetime, null: false
      add :stopped_at, :datetime
      add :duration, :integer, default: 0
      add :ranges, {:array, :map}, default: []

      add :workspace_user_id, references(:workspace_users, on_delete: :delete_all), null: false

      timestamps
    end

    create index(:time_entries, [:workspace_user_id])
  end
end
