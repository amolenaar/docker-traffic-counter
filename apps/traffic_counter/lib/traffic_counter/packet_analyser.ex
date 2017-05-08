defmodule TrafficCounter.PacketAnalyser do
  use GenServer

  @moduledoc false

  require Record
  require TrafficCounter.Interop.IPv4
  require TrafficCounter.Interop.IPv6

  alias TrafficCounter.Interop.IPv4
  alias TrafficCounter.Interop.IPv6


  def start_link(handler) do
    GenServer.start_link(__MODULE__, handler, [name: __MODULE__])
  end

  def init(module) do
    {:ok, {module, host_pattern()}}
  end

  def host_pattern(),
    do: ~r/\nhost:\s*([\w\.]+)/i

  def handle_info({:packet, data_link_type, _time, _length, data}, state = {module, host_pattern}) do
    [_network_layer, internet_layer, _transport_layer, application_layer] = :pkt.decapsulate({data_link_type, data})

    case Regex.run(host_pattern, application_layer) do
      [_all, host] -> module.handle_stat(ip_saddr(internet_layer), host)
      _ -> nil
    end

    {:noreply, state}
  end

  def ip_saddr(data) when IPv4.ipv4?(data), do: IPv4.ipv4(data, :saddr)
  def ip_saddr(data) when IPv6.ipv6?(data), do: IPv6.ipv6(data, :saddr)

end
