defmodule Aoc.Solvers.Day12 do
  @behaviour Aoc.Solver

  @impl Aoc.Solver
  def parse_input(input) do
    input
    |> String.split()
    |> Enum.map(&parse_instruction/1)
  end

  @impl Aoc.Solver
  def solve(1, input) do
    input
    |> Enum.reduce(%{pos: %{row: 0, column: 0}, facing: "E"}, &move_ship/2)
    |> Map.fetch!(:pos)
    |> manhattan_distance()
  end

  defp move_ship({"N", amount}, ship), do: update_in(ship.pos.row, &(&1 - amount))
  defp move_ship({"S", amount}, ship), do: update_in(ship.pos.row, &(&1 + amount))
  defp move_ship({"E", amount}, ship), do: update_in(ship.pos.column, &(&1 + amount))
  defp move_ship({"W", amount}, ship), do: update_in(ship.pos.column, &(&1 - amount))
  defp move_ship({"L", amount}, ship), do: update_in(ship.facing, &rotate(&1, amount))
  defp move_ship({"R", amount}, ship), do: update_in(ship.facing, &rotate(&1, 360 - amount))
  defp move_ship({"F", amount}, ship), do: move_ship({ship.facing, amount}, ship)

  # Rotates counter clockwise (to the left)
  defp rotate(facing, 0), do: facing
  defp rotate("E", amount), do: rotate("N", amount - 90)
  defp rotate("N", amount), do: rotate("W", amount - 90)
  defp rotate("W", amount), do: rotate("S", amount - 90)
  defp rotate("S", amount), do: rotate("E", amount - 90)

  defp manhattan_distance(%{row: row, column: column}), do: abs(row) + abs(column)

  defp parse_instruction(line) do
    {command, amount} = String.split_at(line, 1)
    {command, String.to_integer(amount)}
  end
end
