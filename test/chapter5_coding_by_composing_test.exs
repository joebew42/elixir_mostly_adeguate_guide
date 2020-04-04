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
      replace = fn pattern, replacement -> fn string -> String.replace(string, pattern, replacement) end end
      to_lower_case = fn string -> String.downcase(string) end

      snake_case = compose(replace.(~r/\s+/, "_"), to_lower_case)

      assert snake_case.("my name is Joe") == "my_name_is_joe"
    end

    test "initials" do
      split = fn delimiter -> fn string -> String.split(string, delimiter) end end
      head = fn string -> String.at(string, 0) end
      to_upper_case = fn string -> String.upcase(string) end
      capital_head = compose(to_upper_case, head)
      intercalate = fn symbol -> fn elements -> Enum.join(elements, symbol) <> symbol end end
      initials = compose(intercalate.(". "), compose(map(capital_head), split.(" ")))

      assert split.(" ").("joe brewery bew") == ["joe", "brewery", "bew"]
      assert head.("joe") == "j"
      assert capital_head.("joe") == "J"
      assert intercalate.(". ").(["J", "B", "B"]) == "J. B. B. "
      assert map(head).(["joe", "brewery", "bew"]) == ["j", "b", "b"]
      assert initials.("joe brewery bew") == "J. B. B. "
    end
  end

  describe "Category Theory" do
    test "is_four_letter_word" do
      is_four = fn length -> length == 4 end
      word_length = fn string -> String.length(string) end
      is_four_letter_word = compose(is_four, word_length)

      assert is_four_letter_word.("SOME")
    end

    test "is_last_in_stock" do
      cars = [
        %{
          name: "Aston Martin One-88",
          horsepower: 650,
          dollar_value: 1450000,
          in_stock: true
        },
        %{
          name: "Aston Martin One-77",
          horsepower: 750,
          dollar_value: 1850000,
          in_stock: true
        }
      ]

      reverse = &Enum.reverse/1
      head = fn [head | _tail] -> head end
      last = compose(head, reverse)
      in_stock = fn %{in_stock: in_stock} = _car -> in_stock end
      is_last_in_stock = compose(in_stock, last)

      assert is_last_in_stock.(cars)
    end

    test "average_dollar_value" do
      cars = [
        %{
          name: "Aston Martin One-88",
          horsepower: 650,
          dollar_value: 1450000,
          in_stock: true
        },
        %{
          name: "Aston Martin One-77",
          horsepower: 750,
          dollar_value: 1850000,
          in_stock: true
        }
      ]

      dollar_values = map(& &1.dollar_value)
      sum_all = reduce(& &1 + &2, 0)
      total_dollar_values = compose(sum_all, dollar_values)

      divide_by = fn(by) -> fn(x) -> x / by end end
      divide_by_length_of = compose(divide_by, &length/1)

      average_dollar_value = compose(divide_by_length_of.(cars), total_dollar_values)

      assert average_dollar_value.(cars) == (1450000 + 1850000) / 2
    end
  end

  def reduce(reducer, accumulator) do
    fn elements ->
      do_reduce(reducer, accumulator, elements)
    end
  end

  def do_reduce(_reducer, accumulator, []) do
    accumulator
  end
  def do_reduce(reducer, accumulator, [element | rest]) do
    do_reduce(reducer, reducer.(element, accumulator), rest)
  end

  def compose(f, g) do
    fn x ->
      f.(g.(x))
    end
  end

  def map(function) do
    fn elements ->
      do_map(function, Enum.reverse(elements), [])
    end
  end

  defp do_map(_function, [], acc) do
    acc
  end
  defp do_map(function, [head|rest], acc) do
    do_map(function, rest, [function.(head) | acc])
  end
end
