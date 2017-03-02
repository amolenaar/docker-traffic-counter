defmodule TrafficCounter.PrometheusHandler do
  @behaviour TrafficCounter.Handler
  use Prometheus.Metric

  @moduledoc false

  require Logger

  alias TrafficCounter.ContainerNameResolver

  def setup() do
        Counter.declare([name: :service_request_count,
                         help: "Service request count.",
                         labels: [:src, :dest]])
  end

  def handle_stat(source_ip, target_host) do

    name = ContainerNameResolver.lookup(source_ip)

    Logger.debug("Recording activity between #{name} and #{target_host}")

    Counter.inc([name: :service_request_count,
                 labels: [name, target_host]])

  end
end
