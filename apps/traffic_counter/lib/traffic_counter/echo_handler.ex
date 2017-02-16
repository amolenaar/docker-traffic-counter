defmodule TrafficCounter.EchoHandler do
  @behaviour TrafficCounter.Handler

  def handle_stat(src_addr, dest_host) do
    IO.puts "Packet #{inspect src_addr} -> #{dest_host}"
  end

end
