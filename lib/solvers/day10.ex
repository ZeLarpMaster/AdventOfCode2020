defmodule Aoc.Solvers.Day10 do
  @behaviour Aoc.Solver

  @ets_name :aoc_day10

  @impl Aoc.Solver
  def parse_input(input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> insert_device()
  end

  @impl Aoc.Solver
  def solve(1, input) do
    input
    |> Enum.sort()
    |> Enum.reduce({0, %{1 => 0, 2 => 0, 3 => 0}}, fn val, {prev, map} ->
      {val, update_in(map[val - prev], &(&1 + 1))}
    end)
    |> elem(1)
    |> output()
  end

  def solve(2, input) do
    :ets.new(@ets_name, [:set, :private, :named_table])
    count_paths(MapSet.new([0 | input]), 0, Enum.max(input))
  end

  defp count_paths(adapters, index, last) do
    cond do
      not MapSet.member?(adapters, index) ->
        0

      index == last ->
        1

      solution = get_solution(index) ->
        solution

      true ->
        1..3
        |> Enum.map(fn delta ->
          count_paths(adapters, index + delta, last)
        end)
        |> Enum.sum()
        |> store_solution(index)
    end
  end

  defp get_solution(value) do
    case :ets.lookup(@ets_name, value) do
      [] -> nil
      [{_value, solution}] -> solution
    end
  end

  defp store_solution(solution, value) do
    :ets.insert(@ets_name, {value, solution})
    solution
  end

  defp output(%{1 => ones, 3 => threes}), do: ones * threes
  defp insert_device(list), do: [Enum.max(list) + 3] ++ list
end
