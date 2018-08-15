defmodule Chapter5CodingByComposingTest do
  use ExUnit.Case, async: true

  test "Functional Husbandry" do
    to_upper_case = fn string -> String.upcase(string) end
    exclaim = fn string -> "#{string}!" end
    shout = compose(exclaim, to_upper_case)

    assert shout.("send in the clowns") == "SEND IN THE CLOWNS!"
  end

  def compose(f, g) do
    fn x ->
      f.(g.(x))
    end
  end
end
