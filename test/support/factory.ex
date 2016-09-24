defmodule PhoenixToggl.Factory do
  use ExMachina.Ecto, repo: PhoenixToggl.Repo

  alias PhoenixToggl.{User, Workspace}

  def user_factory do
    %User{
      first_name: sequence(:first_name, &"First #{&1}"),
      last_name: sequence(:last_name, &"Last #{&1}"),
      email: sequence(:email, &"email-#{&1}@foo.com"),
      encrypted_password: "12345678"
    }
  end

  def workspace_factory do
    %Workspace{
      name: sequence(:name, &"Workspace #{&1}")
    }
  end

  def with_workspace(user) do
    insert(:workspace, user_id: user.id)
    user
  end
end
