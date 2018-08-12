defmodule Chapter2FirstClassFunctionsTest do
  use ExUnit.Case, async: true

  test "A quick review" do
    hi = fn(name) -> "Hi #{name}" end
    greeting = hi

    assert hi.("jonas") == "Hi jonas"
    assert greeting.("jonas") == "Hi jonas"
  end
end