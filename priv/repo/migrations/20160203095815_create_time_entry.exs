defmodule PhoenixToggl.Repo.Migrations.CreateTimeEntry do
  use Ecto.Migration

  def change do
    create table(:time_entries) do
      add :description, :text
      add :started_at, :datetime, null: false
      add :stopped_at, :datetime
      add :duration, :integer, default: 0
      add :ranges, {:array, :map}, default: []

      add :workspace_id, references(:workspaces, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps
    end

    create index(:time_entries, [:workspace_id])
    create index(:time_entries, [:user_id])
  end
end
