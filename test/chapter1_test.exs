defmodule Chapter1Test do
  use ExUnit.Case, async: true

  describe "A brief encounter." do
    test "Flocks, conjoin and breed" do
      conjoin = fn a, b -> a + b end
      breed = fn a, b -> a * b end

      flock_a = 4
      flock_b = 2
      flock_c = 0

      result =
        flock_a
        |> conjoin.(flock_c)
        |> breed.(flock_b)
        |> conjoin.(breed.(flock_a, flock_b))

      assert result == 16
    end

    test "True identities" do
      add = fn a, b -> a + b end
      multiply = fn a, b -> a * b end

      flock_a = 4
      flock_b = 2
      flock_c = 0

      result =
        flock_a
        |> add.(flock_c)
        |> multiply.(flock_b)
        |> add.(multiply.(flock_a, flock_b))

      assert result == 16
    end

    test "We gain the knowledge of the ancients" do
      add = fn a, b -> a + b end
      multiply = fn a, b -> a * b end

      a = 2
      b = 4
      c = 6

      # associative
      assert add.(a, add.(b, c)) == add.(add.(a, b), c)

      # commutative
      assert add.(a, b) == add.(b, a)

      # identity
      assert add.(a, 0) == a

      # distributive
      assert multiply.(a, add.(b, c)) == add.(multiply.(a, b), multiply.(a, c))
    end

    test "Simplified with the ancient properties" do
      add = fn a, b -> a + b end
      multiply = fn a, b -> a * b end

      flock_a = 4
      flock_b = 2
      flock_c = 0

      # original
      assert add.(multiply.(flock_b, add.(flock_a, flock_c)), multiply.(flock_a, flock_b)) == 16

      # apply the identity property to remove the extra add.
      assert add.(multiply.(flock_b, flock_a), multiply.(flock_a, flock_b)) == 16

      # apply the distributive property
      assert multiply.(flock_b, add.(flock_a, flock_a))
    end
  end
end
