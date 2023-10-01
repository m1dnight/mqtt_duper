defmodule MqttDuperTest do
  use ExUnit.Case

  doctest MqttDuper

  test "greets the world" do
    assert MqttDuper.hello() == :world
  end
end
