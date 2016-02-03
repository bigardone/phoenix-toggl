defmodule PhoenixToggl.Repo.Migrations.CreateTimeEntry do
  use Ecto.Migration

  def change do
    create table(:workspace_users) do
      add :workspace_id, references(:workspaces, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps
    end

    create index(:workspace_users, [:workspace_id])
    create index(:workspace_users, [:user_id])
  end
end
