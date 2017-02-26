defmodule Web.PrometheusHandler do
  @behaviour TrafficCounter.Handler
  use Prometheus.Metric

  @moduledoc false

  # TODO: Move this module to TrafficCounter app
  require Logger
  require TrafficCounter.Interop.Hostent

  alias TrafficCounter.Interop.Hostent

  def handle_stat(source_ip, target_host) do
#    {:ok, hostent} = :inet.gethostbyaddr(source_ip)
#    name = Hostent.hostent(hostent, :h_name)
    name = source_ip |> Tuple.to_list |> Enum.join(".")

    Logger.debug("Recording activity between #{name} and #{target_host}")

    Counter.inc([name: :blaze_service_request_count,
                 labels: [name, target_host]])

  end
end
