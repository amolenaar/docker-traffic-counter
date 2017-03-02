use Mix.Config

config :traffic_counter,
  interface: 'docker0'

config :logger,
  backends: [:console],
  compile_time_purge_level: :info
