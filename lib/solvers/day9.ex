defmodule Aoc.Solvers.Day9 do
  @behaviour Aoc.Solver

  @preamble_size 25

  @impl Aoc.Solver
  def parse_input(input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  @impl Aoc.Solver
  def solve(1, input) do
    preamble = Enum.take(input, @preamble_size)
    leftover = Enum.drop(input, @preamble_size)

    find_invalid(preamble, leftover)
  end

  defp find_invalid(_, []), do: "Nothing found :("

  defp find_invalid(list, [value | values]) do
    if check_value(MapSet.new(list), value) do
      new_list = tl(list) ++ [value]
      find_invalid(new_list, values)
    else
      value
    end
  end

  defp check_value(set, value) do
    Enum.any?(set, fn v -> MapSet.member?(set, value - v) end)
  end
end
