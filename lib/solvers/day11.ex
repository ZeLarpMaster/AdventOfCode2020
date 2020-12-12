defmodule Aoc.Solvers.Day11 do
  @behaviour Aoc.Solver

  @seat_char "L"

  @impl Aoc.Solver
  def parse_input(input) do
    input
    |> String.split("\n")
    |> parse_into_positions()
  end

  @impl Aoc.Solver
  def solve(1, input) do
    input
    |> simulate_until_unchange()
    |> Enum.count(fn {_, seat} -> seat == :occupied_seat end)
  end

  defp simulate_until_unchange(map) do
    new_map =
      map
      |> Enum.map(fn {position, _seat} = element -> {position, simulate_seat(map, element)} end)
      |> Map.new()

    if new_map == map do
      map
    else
      simulate_until_unchange(new_map)
    end
  end

  defp simulate_seat(map, {{row, column}, seat}) do
    case count_around(map, {row, column}) do
      0 when seat == :empty_seat -> :occupied_seat
      count when count >= 4 and seat == :occupied_seat -> :empty_seat
      _ -> seat
    end
  end

  defp count_around(map, {row, column}) do
    for dx <- -1..1, dy <- -1..1, {dx, dy} != {0, 0} do
      Map.get(map, {row + dy, column + dx}, :floor)
    end
    |> Enum.count(&(&1 == :occupied_seat))
  end

  defp parse_into_positions(rows) do
    rows
    |> Enum.with_index()
    |> Enum.flat_map(fn {columns, row} -> parse_row(row, columns) end)
    |> Map.new()
  end

  defp parse_row(row, columns) do
    columns
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.filter(fn {seat, _} -> seat == @seat_char end)
    |> Enum.map(fn {_, column} -> {{row, column}, :empty_seat} end)
  end
end
