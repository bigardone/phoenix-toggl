defmodule PhoenixToggl.IntegrationCase do
  use ExUnit.CaseTemplate
  use Hound.Helpers
  import PhoenixToggl.Factory

  alias PhoenixToggl.{Repo, User}

  using do
    quote do
      use Hound.Helpers

      import Ecto, only: [build_assoc: 2]
      import Ecto.Model
      import Ecto.Query, only: [from: 2]
      import PhoenixToggl.Router.Helpers
      import PhoenixToggl.Factory
      import PhoenixToggl.IntegrationCase

      alias PhoenixToggl.Repo

      # The default endpoint for testing
      @endpoint PhoenixToggl.Endpoint

      hound_session
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(PhoenixToggl.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(PhoenixToggl.Repo, {:shared, self()})
    end

    :ok
  end

  def create_user do
    build(:user)
    |> User.changeset(%{password: "12345678"})
    |> Repo.insert!
  end

  def user_sign_in(%{user: user}) do
    navigate_to "/"

    sign_in_form = find_element(:id, "sign_in_form")

    sign_in_form
    |> find_within_element(:id, "user_email")
    |> fill_field(user.email)

    sign_in_form
    |> find_within_element(:id, "user_password")
    |> fill_field(user.password)

    sign_in_form
    |> find_within_element(:css, "button")
    |> click

    assert element_displayed?({:id, "authentication_container"})
  end
end
