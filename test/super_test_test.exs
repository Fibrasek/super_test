defmodule SuperTestTest do
  use ExUnit.Case
  doctest SuperTest

  test "greets the world" do
    assert SuperTest.hello() == :world
  end
end
