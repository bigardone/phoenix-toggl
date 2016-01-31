defmodule PhoenixToggl.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string, null: false
      add :last_name, :string
      add :email, :string, null: false
      add :encrypted_password, :string, null: false

      timestamps
    end

    create unique_index(:users, [:email])
  end
end
