use Mix.Config

config :wtt,
  wall_prob: 0

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :wtt_web, WttWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
