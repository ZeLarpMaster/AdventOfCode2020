defmodule Aoc.Solvers.Day6 do
  @behaviour Aoc.Solver

  @impl Aoc.Solver
  def parse_input(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(&String.split/1)
    |> Enum.map(&strings_to_sets/1)
  end

  @impl Aoc.Solver
  def solve(1, input), do: input |> Enum.map(&union_sets/1) |> sum_set_size()
  def solve(2, input), do: input |> Enum.map(&intersect_sets/1) |> sum_set_size()

  defp sum_set_size(sets), do: Enum.sum(Enum.map(sets, &MapSet.size/1))
  defp union_sets(sets), do: Enum.reduce(sets, &MapSet.union/2)
  defp intersect_sets(sets), do: Enum.reduce(sets, &MapSet.intersection/2)
  defp strings_to_sets(strings), do: Enum.map(strings, &string_to_set/1)
  defp string_to_set(string), do: MapSet.new(String.graphemes(string))
end
