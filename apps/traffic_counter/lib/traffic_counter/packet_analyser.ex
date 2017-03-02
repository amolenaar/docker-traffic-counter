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
    {:ok, {module}}
  end

  def handle_info({:packet, data_link_type, _time, _length, data}, state = {module}) do
    [_network_layer, internet_layer, _transport_layer, application_layer] = :pkt.decapsulate({data_link_type, data})
    # TODO: Match 'host:' case insenitive
    with {host_offset, host_length} <- :binary.match(application_layer, "Host: "),
         address_offset             <- host_offset + host_length,
         {crlf_offset, _length}     <- :binary.match(application_layer, <<13, 10>>,
                                                     scope: {address_offset, byte_size(application_layer) - address_offset}),
         host                       <- :binary.part(application_layer, address_offset, crlf_offset - address_offset) do
          module.handle_stat(ip_saddr(internet_layer), host)
    end
    {:noreply, state}
  end

  def ip_saddr(data) when IPv4.ipv4?(data), do: IPv4.ipv4(data, :saddr)
  def ip_saddr(data) when IPv6.ipv6?(data), do: IPv6.ipv6(data, :saddr)

end

