defmodule PhoenixToggl.PageControllerTest do
  use PhoenixToggl.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Hello PhoenixToggl!"
  end
end
