defmodule Aoc.Solvers.Day6 do
  @behaviour Aoc.Solver

  @impl Aoc.Solver
  def parse_input(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(&String.replace(&1, "\n", ""))
    |> Enum.map(&MapSet.new(String.graphemes(&1)))
  end

  @impl Aoc.Solver
  def solve(1, input) do
    input
    |> Enum.map(&MapSet.size/1)
    |> Enum.sum()
  end
end
