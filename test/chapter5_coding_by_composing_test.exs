defmodule Chapter5CodingByComposingTest do
  use ExUnit.Case, async: true

  describe "Functional Husbandry" do
    test "compose" do
      to_upper_case = fn string -> String.upcase(string) end
      exclaim = fn string -> "#{string}!" end
      shout = compose(exclaim, to_upper_case)

      assert shout.("send in the clowns") == "SEND IN THE CLOWNS!"
    end

    test "composition is associative" do
      to_upper_case = fn string -> String.upcase(string) end
      reverse = &Enum.reverse/1
      head = fn [head | _tail] -> head end

      arg = ["jumpkick", "roundhouse", "uppercut"]

      assert head.(arg) == "jumpkick"
      assert reverse.(arg) == ["uppercut", "roundhouse", "jumpkick"]

      # associative
      shout1 = compose(to_upper_case, compose(head, reverse))
      shout2 = compose(compose(to_upper_case, head), reverse)

      assert shout1.(arg) == shout2.(arg)
    end
  end

  describe "Pointfree" do
    test "means that never mention data upon which they operate" do
      snake_case = fn _nothing -> "my_name_is_joe" end

      assert snake_case.("my name is Joe") == "my_name_is_joe"
    end
  end

  def compose(f, g) do
    fn x ->
      f.(g.(x))
    end
  end
end
