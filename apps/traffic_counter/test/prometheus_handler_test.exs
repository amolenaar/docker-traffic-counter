defmodule PrometheusHandlerTest do
  use ExUnit.Case

  @moduledoc false

  test "extract container name from full name" do
    assert TrafficCounter.PrometheusHandler.extract_container_name("amolenaar/traffic-counter:0.1.0.23-79d454774a") == "traffic-counter"
  end
end
