defmodule Chapter4CurryingTest do
  use ExUnit.Case, async: true

  test "add an increment" do
    add = fn a ->
      fn b ->
        a + b
      end
    end

    increment = add.(1)
    add_ten = add.(10)

    assert increment.(2) == 3
    assert add_ten.(2) == 12
  end
end
