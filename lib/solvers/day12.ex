defmodule Aoc.Solvers.Day12 do
  @behaviour Aoc.Solver

  @default_ship %{
    pos: %{row: 0, column: 0},
    facing: "E",
    waypoint: %{row: -1, column: 10}
  }

  @impl Aoc.Solver
  def parse_input(input) do
    input
    |> String.split()
    |> Enum.map(&parse_instruction/1)
  end

  @impl Aoc.Solver
  def solve(1, input) do
    input
    |> Enum.reduce(@default_ship, &move_ship/2)
    |> Map.fetch!(:pos)
    |> manhattan_distance()
  end

  def solve(2, input) do
    input
    |> Enum.reduce(@default_ship, &move_waypoint/2)
    |> Map.fetch!(:pos)
    |> manhattan_distance()
  end

  defp move_waypoint({"N", amount}, ship), do: update_in(ship.waypoint.row, &(&1 - amount))
  defp move_waypoint({"S", amount}, ship), do: update_in(ship.waypoint.row, &(&1 + amount))
  defp move_waypoint({"E", amount}, ship), do: update_in(ship.waypoint.column, &(&1 + amount))
  defp move_waypoint({"W", amount}, ship), do: update_in(ship.waypoint.column, &(&1 - amount))
  defp move_waypoint({"L", amount}, ship), do: update_in(ship.waypoint, &flip(&1, amount))
  defp move_waypoint({"R", amount}, ship), do: update_in(ship.waypoint, &flip(&1, 360 - amount))
  defp move_waypoint({"F", amount}, ship), do: move_forward(ship, amount)

  defp move_ship({"N", amount}, ship), do: update_in(ship.pos.row, &(&1 - amount))
  defp move_ship({"S", amount}, ship), do: update_in(ship.pos.row, &(&1 + amount))
  defp move_ship({"E", amount}, ship), do: update_in(ship.pos.column, &(&1 + amount))
  defp move_ship({"W", amount}, ship), do: update_in(ship.pos.column, &(&1 - amount))
  defp move_ship({"L", amount}, ship), do: update_in(ship.facing, &rotate(&1, amount))
  defp move_ship({"R", amount}, ship), do: update_in(ship.facing, &rotate(&1, 360 - amount))
  defp move_ship({"F", amount}, ship), do: move_ship({ship.facing, amount}, ship)

  defp move_forward(ship, amount) do
    ship = update_in(ship.pos.row, &(&1 + ship.waypoint.row * amount))
    update_in(ship.pos.column, &(&1 + ship.waypoint.column * amount))
  end

  # Rotates counter clockwise (to the left)
  defp rotate(direction, 0), do: direction
  defp rotate("E", amount), do: rotate("N", amount - 90)
  defp rotate("N", amount), do: rotate("W", amount - 90)
  defp rotate("W", amount), do: rotate("S", amount - 90)
  defp rotate("S", amount), do: rotate("E", amount - 90)

  # Flips the coordinates (performs a 90° rotation counter clockwise)
  defp flip(position, 0), do: position
  defp flip(%{row: y, column: x}, amount), do: flip(%{row: -x, column: y}, amount - 90)

  defp manhattan_distance(%{row: row, column: column}), do: abs(row) + abs(column)

  defp parse_instruction(line) do
    {command, amount} = String.split_at(line, 1)
    {command, String.to_integer(amount)}
  end
end
