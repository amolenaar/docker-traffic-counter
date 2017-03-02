use Mix.Config

import_config "#{Mix.env}.exs"

config :web,
  port: 9100

config :prometheus, Web.MetricsExporter,
  path: "/metrics",
  format: :auto, ## or :protobuf, or :text
  registry: :default,
  auth: false

config :traffic_counter,
  handler: TrafficCounter.PrometheusHandler
