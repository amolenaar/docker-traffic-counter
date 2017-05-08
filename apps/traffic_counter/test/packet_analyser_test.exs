defmodule PacketAnalyserTest do
  use ExUnit.Case
  doctest TrafficCounter

  @moduledoc false

  def handle_stat(source_ip, target_host) do
    assert source_ip == {127, 0, 0, 1}
    assert target_host == "localhost"
  end

  test "should send event for HTTP packets" do
    {:ok, data} = Base.decode16 "020000004500029FD3854000400600007F0000017F000001D5850FA00CE107A032F5A2D6801831CB009400000101080A58CE647F58CE3C50474554202F746573742E68746D6C20485454502F312E310D0A486F73743A206C6F63616C686F73743A343030300D0A436F6F6B69653A205F67613D4741312E312E3139333731353131392E313438363133383830303B205F6761743D313B20687564736F6E5F6175746F5F726566726573683D747275653B20746578746175746F666F726D61743D66616C73653B2074657874777261706F6E3D66616C73653B20777973697779673D74657874617265613B206A656E6B696E732D74696D657374616D7065723D73"
    TrafficCounter.PacketAnalyser.handle_info({:packet, 0, 0, 0, data}, {__MODULE__, TrafficCounter.PacketAnalyser.host_pattern()})
  end

  test "host pattern should match domain names" do
    assert [_all, "example.com"] = Regex.run(TrafficCounter.PacketAnalyser.host_pattern(), "Header: xx\r\nHost: example.com")
    assert [_all, "example.com"] = Regex.run(TrafficCounter.PacketAnalyser.host_pattern(), "Header: xx\r\nHost: example.com:80")
  end
end



