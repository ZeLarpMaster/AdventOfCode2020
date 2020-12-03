defmodule Aoc.SolversTest do
  use ExUnit.Case

  for "day" <> file <- File.ls!("known_answers"), day = String.replace(file, ".txt", "") do
    describe "day #{day}" do
      for part <- [1, 2],
          expectation = Aoc.KnownAnswer.get_answer(day, part),
          expectation != nil do
        test "part #{part}" do
          args = [unquote(part), Aoc.Input.get_raw(unquote(day))]
          answer = apply(:"Elixir.Aoc.Solvers.Day#{unquote(day)}", :solve, args)

          assert inspect(answer) == unquote(expectation)
        end
      end
    end
  end
end
