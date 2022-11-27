import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tic_tac_toe, TicTacToeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "MgjA4Gz5WQplPbgdQkWtKsLY6gxZXSYQSZbr4o/BkQ5E4jzdGyCs1HktRni9689r",
  server: false

# In test we don't send emails.
config :tic_tac_toe, TicTacToe.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
