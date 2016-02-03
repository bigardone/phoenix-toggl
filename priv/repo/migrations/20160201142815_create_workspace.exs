defmodule PhoenixToggl.Repo.Migrations.CreateWorkspace do
  use Ecto.Migration

  def change do
    create table(:workspaces) do
      add :name, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps
    end

    create index(:workspaces, [:user_id])
  end
end
