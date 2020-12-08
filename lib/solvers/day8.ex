defmodule Aoc.Solvers.Day8 do
  @behaviour Aoc.Solver

  @impl Aoc.Solver
  def parse_input(input) do
    Aoc.Handheld.new(input)
  end

  @impl Aoc.Solver
  def solve(1, input) do
    input
    |> Aoc.Handheld.run_until_loop()
  end
end
