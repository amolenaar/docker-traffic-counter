defmodule TrafficCounter do
  use Application

  @moduledoc false

  alias TrafficCounter.PacketAnalyser
  alias TrafficCounter.FolsomHandler

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    exec = Application.get_env(:traffic_counter, :exec, '')
    interface = Application.get_env(:traffic_counter, :interface)
    handler = Application.get_env(:traffic_counter, :handler, TrafficCounter.FolsomHandler)

    children = [
      worker(PacketAnalyser, [handler]),
      worker(:epcap, [PacketAnalyser, [exec: exec, snaplen: 256, interface: interface, promiscuous: true, filter: 'tcp']])
    ]

    opts = [strategy: :one_for_all, name: TrafficCounter.Sup]
    Supervisor.start_link(children, opts)
  end
end
