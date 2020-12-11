defmodule Aoc.Solvers.Day10 do
  @behaviour Aoc.Solver

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

  defp output(%{1 => ones, 3 => threes}), do: ones * threes
  defp insert_device(list), do: [Enum.max(list) + 3] ++ list
end
