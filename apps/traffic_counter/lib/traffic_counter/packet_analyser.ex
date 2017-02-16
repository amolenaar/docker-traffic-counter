defmodule TrafficCounter.PacketAnalyser do
  use GenServer
  @moduledoc false

  def start_link(handler) do
    GenServer.start_link(__MODULE__, handler, [name: __MODULE__])
  end

  def init(module) do
    {:ok, {module}}
  end

  def handle_info({:packet, data_link_type, _time, _length, data}, state={module}) do
    [_network_layer, internet_layer, _transport_layer, application_layer] = :pkt.decapsulate({data_link_type, data})
    with {host_offset, host_length} <- :binary.match(application_layer, "Host: "),
         address_offset             <- host_offset + host_length,
         {crlf_offset, _length}     <- :binary.match(application_layer, <<13, 10>>,
                                                     [scope: {address_offset, byte_size(application_layer) - address_offset}]),
         host                       <- :binary.part(application_layer, address_offset, crlf_offset - address_offset) do
          module.handle_stat(ip_addr(internet_layer), host)
    end
    {:noreply, state}
  end

  defp ip_addr({:ipv4, _v, _hl, _tos, _len, _id, _df, _mf, _off, _ttl, _p, _sum, saddr, _daddr, _opt}), do: saddr

  defp ip_addr({:ipv6,  _v, _class, _flow, _len, _next, _hop, saddr, _daddr}), do: saddr

end

