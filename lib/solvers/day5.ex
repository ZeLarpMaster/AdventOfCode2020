defmodule Aoc.Solvers.Day5 do
  @behaviour Aoc.Solver

  @impl Aoc.Solver
  def parse_input(input) do
    input
    |> String.split()
    |> Enum.map(&parse_seat/1)
  end

  @impl Aoc.Solver
  def solve(1, input) do
    Enum.max(input)
  end

  def solve(2, input) do
    input
    |> Enum.sort()
    |> Enum.with_index(Enum.min(input))
    |> Enum.find(fn {id, index} -> id != index end)
    |> elem(0)
    |> Kernel.-(1)
  end

  defp parse_seat(line) do
    line
    |> String.replace("F", "0")
    |> String.replace("B", "1")
    |> String.replace("L", "0")
    |> String.replace("R", "1")
    |> String.to_integer(2)
  end
end
