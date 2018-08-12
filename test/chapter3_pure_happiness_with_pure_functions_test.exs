defmodule Chapter3PureHappinessWithPureFunctionsTest do
  use ExUnit.Case, async: true

  describe "Oh to be pure again" do
    test "check_age/1 impure" do
      minimum = 21
      check_age = fn age -> age >= minimum end

      refute check_age.(20)
      assert check_age.(21)
    end

    test "check_age/1 pure" do
      check_age = fn age ->
        minimum = 21
        age >= minimum
      end

      refute check_age.(20)
      assert check_age.(21)
    end
  end

  describe "The case of purity" do
    test "cacheable" do
      apply_and_memoize = fn function, arguments, cache ->
        input = List.to_string(arguments)

        case Map.get(cache, input) do
          nil ->
            new_cache = Map.put(cache, input, apply(function, arguments))
            {:ok, Map.get(new_cache, input), new_cache}

          output ->
            {:ok, output, cache}
        end
      end

      result = apply_and_memoize.(fn a, b -> a + b end, [1, 2], %{})

      assert result == {:ok, 3, %{<<1, 2>> => 3}}
    end
  end
end
