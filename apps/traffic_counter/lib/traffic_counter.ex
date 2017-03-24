defmodule TrafficCounter do
  use Application

  @moduledoc false

  alias TrafficCounter.PacketAnalyser
  alias TrafficCounter.ContainerNameResolver

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    exec = Application.get_env(:traffic_counter, :exec, '')
    interface = get_interface()
    handler = Application.get_env(:traffic_counter, :handler, TrafficCounter.EchoHandler)

    handler.setup()

    children = [
      worker(PacketAnalyser, [handler]),
      worker(ContainerNameResolver, []),
      worker(:epcap, [PacketAnalyser, [exec: exec, snaplen: 256, interface: interface, promiscuous: true, filter: 'tcp']])
    ]

    opts = [strategy: :one_for_all, name: TrafficCounter.Sup]
    Supervisor.start_link(children, opts)
  end

  def get_interface() do
    "IF"
    |> System.get_env()
    |> (fn(nil)   -> Application.get_env(:traffic_counter, :interface)
          (iface) -> iface
        end).()
  end
end
