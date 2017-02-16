defmodule TrafficCounter.Handler do
  @moduledoc """
  Behaviour for receiving events from the processing engine.
  """

  @doc """
  * `source_ip` is a ip address tuple (ipv4, or ipv6)
  * `target_host` is the host the packet wants to communicate with
  """
  @callback handle_stat(source_ip :: tuple, target_host :: bitstring) :: atom

end
