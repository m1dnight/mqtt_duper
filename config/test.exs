import Config

config :loomy_data_api, :emqtt, start: false

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :loomy_data_api, LoomyDataApi.Repo,
  username: System.get_env("POSTGRES_USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "postgres",
  database:
    System.get_env("POSTGRES_DB") ||
      "loomy_data_api_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: System.get_env("POSTGRES_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :loomy_data_api, LoomyDataApiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "SzHoyTwxuYZ2ytAbdlV5zOkuQwVbFMIaWZ59z9GM8TzOUv+4US7+4Fpv4K6+KtA6",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :loomy_data_api, tasks: []
config :loomy_data_api, task_interval_minutes: 30

config :loomy_data_api, children: []
