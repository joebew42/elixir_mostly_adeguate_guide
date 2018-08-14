ExUnit.start(trace: true)

defmodule Currying do
  # http://blog.patrikstorm.com/function-currying-in-elixir
  def curry(function) do
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
