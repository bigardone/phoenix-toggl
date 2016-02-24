defmodule PhoenixToggl.SignUpTest do
  use PhoenixToggl.IntegrationCase

  @tag :integration
  test "GET /sign_up" do
    navigate_to "/sign_up"

    assert page_title =~ "Sign up"
    assert element_displayed?({:id, "sign_up_form"})
  end

  @tag :integration
  test "Siginig up with correct data" do
    navigate_to "/sign_up"

    assert element_displayed?({:id, "sign_up_form"})

    sign_up_form = find_element(:id, "sign_up_form")

    sign_up_form
    |> find_within_element(:id, "user_first_name")
    |> fill_field("John")

    sign_up_form
    |> find_within_element(:id, "user_email")
    |> fill_field("john@doe.com")

    sign_up_form
    |> find_within_element(:id, "user_password")
    |> fill_field("12345678")

    sign_up_form
    |> find_within_element(:css, "button")
    |> click

    assert element_displayed?({:id, "authentication_container"})

    assert page_source =~ "John"
    assert page_source =~ "Timer"
    assert page_source =~ "Reports"
  end
end
