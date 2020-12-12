defmodule Aoc.Solvers.Day11 do
  @behaviour Aoc.Solver

  @impl Aoc.Solver
  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.flat_map(fn {columns, row} -> parse_row(row, columns) end)
    |> Map.new()
  end

  @impl Aoc.Solver
  def solve(1, input), do: solve(input, :adjacent, 4)
  def solve(2, input), do: solve(input, :vision, 5)

  defp solve(input, type, threshold) do
    input
    |> preprocess(type, threshold)
    |> simulate_until_unchanged()
    |> Enum.count(fn {_, seat} -> seat == :occupied_seat end)
  end

  # ===== Simulation functions =====
  defp simulate_until_unchanged(map) do
    new_map =
      map.map
      |> Enum.map(fn {position, _seat} = element -> {position, simulate_seat(map, element)} end)
      |> Map.new()

    if new_map == map.map do
      new_map
    else
      simulate_until_unchanged(put_in(map.map, new_map))
    end
  end

  defp simulate_seat(%{overcrowded: threshold} = map, {{row, column}, seat}) do
    case count_around(map, {row, column}) do
      0 when seat == :empty_seat -> :occupied_seat
      count when count >= threshold and seat == :occupied_seat -> :empty_seat
      _ -> seat
    end
  end

  defp count_around(map, position) do
    map.nearby
    |> Map.fetch!(position)
    |> Enum.map(&Map.get(map.map, &1, :floor))
    |> Enum.count(&(&1 == :occupied_seat))
  end

  # ===== Parsing/preprocessing functions =====
  defp preprocess(map, type, overcrowd_threshold) do
    %{map: map, nearby: make_nearby_map(map, type), overcrowded: overcrowd_threshold}
  end

  defp make_nearby_map(map, type) do
    map
    |> Enum.map(fn {pos, _} -> {pos, get_nearby(map, pos, type)} end)
    |> Map.new()
  end

  defp get_nearby(map, {row, column}, type) do
    for dx <- -1..1, dy <- -1..1, {dy, dx} != {0, 0} do
      project(map, {row, column}, {dy, dx}, 1, type)
    end
    |> Enum.filter(&(&1 != nil))
  end

  defp project(map, {row, column} = pos, {dy, dx} = delta, factor, type) do
    position = {row + dy * factor, column + dx * factor}
    seat = Map.get(map, position)

    cond do
      seat == nil -> nil
      seat == :floor and type == :vision -> project(map, pos, delta, factor + 1, type)
      true -> position
    end
  end

  defp parse_row(row, columns) do
    columns
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn
      {"L", column} -> {{row, column}, :empty_seat}
      {_, column} -> {{row, column}, :floor}
    end)
  end
end
