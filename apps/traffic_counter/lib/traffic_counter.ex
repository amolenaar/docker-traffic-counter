defmodule TrafficCounter do
  use Application

  @moduledoc false

  alias TrafficCounter.PacketAnalyser
  alias TrafficCounter.ElixometerHandler

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    interface = Application.get_env(:traffic_counter, :interface, 'lo0')
    children = [
      worker(PacketAnalyser, [ElixometerHandler]),
      worker(:epcap, [PacketAnalyser, [snaplen: 256, interface: interface, promiscuous: true, filter: 'tcp']])
    ]

    opts = [strategy: :one_for_all, name: TrafficCounter.Sup]
    Supervisor.start_link(children, opts)
  end
end
