defmodule Aoc.Solvers.Day13 do
  @behaviour Aoc.Solver

  @impl Aoc.Solver
  def parse_input(input) do
    input
    |> String.split()
    |> parse_bus_schedules()
  end

  @impl Aoc.Solver
  def solve(1, {earliest, bus_ids}) do
    Stream.iterate(earliest, &(&1 + 1))
    |> Enum.find_value(&bus_intersects?(&1, bus_ids))
    |> output(earliest)
  end

  defp output({time, bus_id}, earliest), do: bus_id * (time - earliest)

  defp bus_intersects?(time, bus_ids) do
    Enum.find_value(bus_ids, fn bus_id ->
      if rem(time, bus_id) == 0, do: {time, bus_id}
    end)
  end

  defp parse_bus_schedules([early_stamp, bus_ids]) do
    {String.to_integer(early_stamp), parse_ids(bus_ids)}
  end

  defp parse_ids(bus_ids) do
    bus_ids
    |> String.split(",")
    |> Enum.filter(&(&1 != "x"))
    |> Enum.map(&String.to_integer/1)
  end
end
