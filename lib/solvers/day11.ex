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
    |> preprocess(:adjacent, 4)
    |> simulate_until_unchange()
    |> Enum.count(fn {_, seat} -> seat == :occupied_seat end)
  end

  defp simulate_until_unchange(map) do
    new_map = simulate_step(map)

    if new_map.map == map.map do
      map.map
    else
      simulate_until_unchange(new_map)
    end
  end

  defp simulate_step(map) do
    new_map =
      map.map
      |> Enum.map(fn {position, _seat} = element -> {position, simulate_seat(map, element)} end)
      |> Map.new()

    put_in(map.map, new_map)
  end

  defp simulate_seat(%{overcrowded: threshold} = map, {{row, column}, seat}) do
    case count_around(map, {row, column}) do
      0 when seat == :empty_seat -> :occupied_seat
      count when count >= threshold and seat == :occupied_seat -> :empty_seat
      _ -> seat
    end
  end

  defp count_around(map, position) do
    for position_around <- Map.fetch!(map.nearby, position) do
      Map.get(map.map, position_around, :floor)
    end
    |> Enum.count(&(&1 == :occupied_seat))
  end

  defp preprocess(map, type, overcrowd_threshold) do
    nearby_map =
      map
      |> Enum.map(fn {pos, _} -> {pos, get_nearby(map, pos, type)} end)
      |> Map.new()

    %{map: map, nearby: nearby_map, overcrowded: overcrowd_threshold}
  end

  defp get_nearby(_map, {row, column}, :adjacent) do
    for dx <- -1..1, dy <- -1..1, {dx, dy} != {0, 0} do
      {row + dy, column + dx}
    end
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
