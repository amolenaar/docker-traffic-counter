defmodule TrafficCounter.Interop.IPv4 do
  require Record

  Record.defrecord :ipv4, Record.extract(:ipv4,  from: "../../deps/pkt/include/pkt.hrl")

  defmacro ipv4?(data) do
    quote do: Record.is_record(unquote(data), :ipv4)
  end

end

defmodule TrafficCounter.Interop.IPv6 do
  require Record

  Record.defrecord :ipv6, Record.extract(:ipv6,  from: "../../deps/pkt/include/pkt.hrl")

  defmacro ipv6?(data) do
    quote do: Record.is_record(unquote(data), :ipv6)
  end

end

defmodule TrafficCounter.Interop.Hostent do
  require Record

  Record.defrecord :hostent, Record.extract(:hostent,  from_lib: "kernel/include/inet.hrl")
end
