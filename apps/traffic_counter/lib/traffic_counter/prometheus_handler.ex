defmodule TrafficCounter.PrometheusHandler do
  @behaviour TrafficCounter.Handler
  use Prometheus.Metric

  @moduledoc false

  require Logger

  alias TrafficCounter.ContainerNameResolver

  def setup() do
        Counter.declare([name: :service_request_count,
                         help: "Service request count.",
                         labels: [:src, :container, :container_name, :dest]])
  end

  def handle_stat(source_ip, target_host) do
    container = ContainerNameResolver.lookup(source_ip)
    container_name = extract_container_name(container)

    Logger.debug("Recording activity between #{container} (#{source_ip}) and #{target_host}")

    Counter.inc([name: :service_request_count,
                 labels: [format_ip(source_ip), container, container_name, target_host]])
  end

  def format_ip({a, b, c, d}), do: "#{a}.#{b}.#{c}.#{d}"

  def extract_container_name(container) do
    container
    |> String.split("/")
    |> Enum.at(-1)
    |> String.split(":")
    |> Enum.at(0)
  end
end
