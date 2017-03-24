defmodule TrafficCounterTest do
  use ExUnit.Case
  doctest TrafficCounter

  test "can parse ipv4 record" do
    assert {10, 192, 168, 111} == TrafficCounter.PacketAnalyser.ip_saddr({:ipv4, 4, 5, 0, 533, 50_569, 1, 0, 0, 64, 6, 31_686, {10, 192, 168, 111}, {198, 232, 125, 123}, ""})
  end

end
