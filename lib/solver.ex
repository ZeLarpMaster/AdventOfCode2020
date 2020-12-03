defmodule Aoc.Solver do
  @moduledoc "Behaviour for solvers"

  @doc "Solving the part's problem"
  @callback solve(part :: 1 | 2, input :: any) :: any

  @doc "Parse the input string into a comprehensible data structure for the day"
  @callback parse_input(input :: String.t()) :: any

  @doc "Execute the solver for a day and part with an input"
  @spec solve(pos_integer, 1 | 2, String.t()) :: any
  def solve(day, part, input) do
    day_module = :"Elixir.Aoc.Solvers.Day#{day}"
    parsed_input = apply(day_module, :parse_input, [input])
    apply(day_module, :solve, [part, parsed_input])
  end
end
