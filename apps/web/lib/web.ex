defmodule Web do
  use Application

  @moduledoc false

  require Logger
  require Prometheus.Metric.Counter

  alias Web.Router
  alias Plug.Adapters.Cowboy
  alias Prometheus.Metric.Counter

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    port = Application.get_env(:web, :port, 5000)

    Web.MetricsExporter.setup()

    Counter.declare([name: :blaze_service_request_count,
                     help: "Service request count.",
                     labels: [:src, :dest]])

    Logger.info "Startic Prometheus metrics endpoint on port http://localhost:#{port}/metrics"
    children = [
      Cowboy.child_spec(:http, Router, [], port: port, acceptors: 10)
    ]

    opts = [strategy: :one_for_one, name: Web]
    Supervisor.start_link(children, opts)
  end
end
