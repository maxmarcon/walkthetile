import Config

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :wtt_web, WttWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  url: [
    host: System.get_env("URL_HOST", "localhost"),
    port: System.get_env("URL_PORT", "4000"),
    scheme: System.get_env("URL_SCHEME", "http")
  ],
  server: true,
  secret_key_base: secret_key_base
