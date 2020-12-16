defmodule Aoc.Solvers.Day15 do
  @behaviour Aoc.Solver

  @impl Aoc.Solver
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  @impl Aoc.Solver
  def solve(1, input), do: start_speaking(input, 2020)
  def solve(2, input), do: start_speaking(input, 30_000_000)

  defp start_speaking(input, max_turn) do
    {:ok, result} = __MODULE__.Rust.start_speaking(input, max_turn)
    result
  end
end
