
defmodule TrafficCounter.ElixometerHandler do
  @behaviour TrafficCounter.Handler
  use Elixometer

  require TrafficCounter.Interop.Hostent

  alias TrafficCounter.Interop.Hostent

  def handle_stat(source_ip, target_host) do
    {:ok, hostent} = :inet.gethostbyaddr(source_ip)
    name = Hostent.hostent(hostent, :h_name)
    update_counter("traffic_count{from=\"#{name}\",to=\"#{target_host}\"}", 1)
  end

end
