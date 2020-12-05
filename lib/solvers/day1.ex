defmodule Aoc.Solvers.Day1 do
  @behaviour Aoc.Solver

  @impl Aoc.Solver
  def parse_input(input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> MapSet.new()
  end

  @impl Aoc.Solver
  def solve(1, input), do: find_depth_sum(input, 2)
  def solve(2, input), do: find_depth_sum(input, 3)

  defp find_depth_sum(nums, depth) do
    nums
    |> find_depth_sum(depth, fn value ->
      sum = 2020 - Enum.sum(value)
      if Enum.member?(nums, sum), do: [sum | value]
    end)
    |> Enum.reduce(&Kernel.*/2)
  end

  defp find_depth_sum(_nums, 1, fun) do
    fun.([])
  end

  defp find_depth_sum(nums, depth, fun) do
    Enum.find_value(
      nums,
      &find_depth_sum(nums, depth - 1, fn value ->
        fun.([&1 | value])
      end)
    )
  end
end
