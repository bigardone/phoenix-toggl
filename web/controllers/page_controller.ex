defmodule PhoenixToggl.PageController do
  use PhoenixToggl.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
