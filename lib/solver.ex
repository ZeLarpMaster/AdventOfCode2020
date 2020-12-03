defmodule Aoc.Solver do
  @moduledoc "Behaviour for solvers"

  @doc "Defines the function called for running the day's solver"
  @callback solve(day :: 1 | 2, input :: String.t()) :: any()
end
