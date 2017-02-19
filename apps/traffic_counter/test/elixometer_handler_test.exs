defmodule ElixometerHandlerTest do
  use ExUnit.Case

  test "Can handle update" do
    TrafficCounter.ElixometerHandler.handle_stat({127, 0, 0, 1}, "target.host")
  end
end
