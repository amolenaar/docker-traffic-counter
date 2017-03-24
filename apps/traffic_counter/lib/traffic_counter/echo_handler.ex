defmodule TrafficCounter.EchoHandler do
  @behaviour TrafficCounter.Handler
  @moduledoc false

  def setup() do
    :ok
  end

  def handle_stat(src_addr, dest_host) do
    IO.puts "Packet #{inspect src_addr} -> #{dest_host}"
  end

end
