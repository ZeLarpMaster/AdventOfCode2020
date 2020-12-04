defmodule Aoc.Solvers.Day3 do
  @behaviour Aoc.Solver

  @impl Aoc.Solver
  def parse_input(input) do
    input
    |> String.split()
    |> Enum.map(fn line -> {String.length(line), parse_line(line)} end)
  end

  @impl Aoc.Solver
  def solve(1, input) do
    # Input is [{width, set(x coords with trees)}]
    count_trees(0, {3, 1}, input)
  end

  def solve(2, input) do
    [
      {1, 1},
      {3, 1},
      {5, 1},
      {7, 1},
      {1, 2}
    ]
    |> Enum.map(&count_trees(0, &1, input))
    |> Enum.reduce(&Kernel.*/2)
  end

  defp count_trees(_x, {_x_slope, y_slope}, tree_list) when length(tree_list) < y_slope, do: 0

  defp count_trees(x, {dx, dy}, [{width, trees} | next_trees]) do
    has_tree? = MapSet.member?(trees, x)
    counted_tree = if has_tree?, do: 1, else: 0
    new_x = rem(x + dx, width)
    counted_tree + count_trees(new_x, {dx, dy}, Enum.drop(next_trees, dy - 1))
  end

  defp parse_line(line) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.filter(fn {char, _index} -> char == "#" end)
    |> Enum.map(fn {_char, index} -> index end)
    |> MapSet.new()
  end
end
