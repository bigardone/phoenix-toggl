# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :phoenix_toggl, PhoenixToggl.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "fwhgWA/EEgRzxIZuGabA7q+HWvDqgQvQqTHGK99X4H6nL0vUl19Hjv2/+VgWGUhQ",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: PhoenixToggl.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :phoenix_toggl, ecto_repos: [PhoenixToggl.Repo]

# Configure guardian
config :guardian, Guardian,
  issuer: "PhoenixToggl",
  ttl: { 3, :days },
  verify_issuer: true,
  serializer: PhoenixToggl.GuardianSerializer

# Start Hound for ChromeDriver
config :hound, driver: "chrome_driver"
