defmodule PhoenixToggl.UserTest do
  use PhoenixToggl.ModelCase

  alias PhoenixToggl.User

  @valid_attrs %{password: "some content", email: "foo@bar.com", first_name: "some content", last_name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
