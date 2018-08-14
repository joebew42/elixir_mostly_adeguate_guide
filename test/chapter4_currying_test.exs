defmodule Chapter4CurryingTest do
  use ExUnit.Case, async: true

  import Currying

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

  test "curried/1" do
    curried = curry(fn a, b -> a - b end)

    assert curried.(3).(1) == 2
  end

  test "match, replace, filter and map" do
    match = curry(fn what, string -> Regex.match?(what, string) end)
    filter = curry(fn function, enum -> Enum.filter(enum, function) end)
    replace = curry(fn what, replacement, string -> String.replace(string, what, replacement) end)

    assert match.(~r/r/).("hello world")

    has_letter_r? = match.(~r/r/)

    assert has_letter_r?.("hello world")
    refute has_letter_r?.("just j and s and t etc")

    assert filter.(has_letter_r?).(["rock and roll", "smooth jazz"]) == ["rock and roll"]

    remove_strings_without_rs = filter.(has_letter_r?)

    assert remove_strings_without_rs.(["rock and roll", "smooth jazz"]) == ["rock and roll"]

    no_vowels = replace.(~r/[aeiou]/)
    censored = no_vowels.("*")

    assert censored.("Chocolate Rain") == "Ch*c*l*t* R**n"
  end

  describe "Exercises" do
    test "Refactor to remove all arguments by partially applying the function" do
      # words :: String -> [String]
      # const words = str => split(' ', str);
      words = &String.split(&1, " ")

      assert words.("hello world") == ["hello", "world"]

      # filterQs :: [String] -> [String]
      # const filterQs = xs => filter(x => x.match(/q/i), xs);
      match = curry(fn what, string -> Regex.match?(what, string) end)
      filter = curry(fn function, enum -> Enum.filter(enum, function) end)

      has_letter_q? = match.(~r/q/)
      filter_qs = filter.(has_letter_q?)

      assert filter_qs.(["quack", "duck"]) == ["quack"]
    end

    test "Refactor `max` to not reference any arguments using the helper function `keepHighest`." do
      # max :: [Number] -> Number
      # const max = xs => reduce((acc, x) => (x >= acc ? x : acc), -Infinity, xs);
      keep_highest = fn a, b -> if a > b, do: a, else: b end
      reduce = curry(fn function, enum -> Enum.reduce(enum, function) end)
      max = reduce.(keep_highest)

      assert max.([2, 4, 6, 10, 34, 21, 67, 11, 5]) == 67
    end
  end
end
