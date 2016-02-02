use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phoenix_toggl, PhoenixToggl.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :phoenix_toggl, PhoenixToggl.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "phoenix_toggl_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Guardian configuration
config :guardian, Guardian,
  secret_key: "Y8+P3Plvr/7bDo38ySz5s8K1hRpzERiDmmjw4v7W+7EQ2XAFG/qdZhE0xFE8Be8D"
