defmodule Aoc.Solvers.Day1 do
  @behaviour Aoc.Solver

  @impl Aoc.Solver
  def parse_input(input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  @impl Aoc.Solver
  def solve(1, input) do
    [a, b] = find_sum(input)
    a * b
  end

  def solve(2, input) do
    [a, b, c] = find_three_sum(input)
    a * b * c
  end

  defp find_three_sum(nums) do
    map = MapSet.new(nums)

    Enum.find_value(nums, fn a ->
      Enum.find_value(nums, fn b ->
        if MapSet.member?(map, 2020 - a - b) do
          [a, b, 2020 - a - b]
        end
      end)
    end)
  end

  defp find_sum(nums) do
    map = MapSet.new(nums)
    a = Enum.find(nums, fn a -> MapSet.member?(map, 2020 - a) end)
    [a, 2020 - a]
  end
end
