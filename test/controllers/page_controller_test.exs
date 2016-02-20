defmodule PhoenixToggl.PageControllerTest do
  use PhoenixToggl.ConnCase, async: true

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Phoenix Toggl"
  end
end
