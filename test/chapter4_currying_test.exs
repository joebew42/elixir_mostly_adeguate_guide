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

  test "curried/1" do
    curried = curry(fn a, b -> a - b end)

    assert curried.(3).(1) == 2
  end

  test "match" do
    match = curry(fn what, string -> Regex.match?(what, string) end)

    assert match.(~r/r/).("hello world")

    has_letter_r? = match.(~r/r/)

    assert has_letter_r?.("hello world")
    refute has_letter_r?.("just j and s and t etc")

    names = ["joe", "foo", "bar"]

    assert Enum.filter(names, has_letter_r?) == ["bar"]
  end

  # http://blog.patrikstorm.com/function-currying-in-elixir
  defp curry(function) do
    {_, arity} = :erlang.fun_info(function, :arity)
    curry(function, arity, [])
  end

  defp curry(function, 0, arguments) do
    apply(function, Enum.reverse(arguments))
  end

  defp curry(function, arity, arguments) do
    fn argument ->
      curry(function, arity - 1, [argument | arguments])
    end
  end
end
