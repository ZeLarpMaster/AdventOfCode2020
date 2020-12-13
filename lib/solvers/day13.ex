defmodule Aoc.Solvers.Day13 do
  @behaviour Aoc.Solver

  @impl Aoc.Solver
  def parse_input(input) do
    [early_stamp, bus_ids] = String.split(input)
    [String.to_integer(early_stamp), parse_bus_ids(bus_ids)]
  end

  @impl Aoc.Solver
  def solve(1, [earliest, raw_ids]) do
    bus_ids = Enum.filter(raw_ids, &(&1 != 0))

    Stream.iterate(earliest, &(&1 + 1))
    |> Enum.find_value(&find_departing_bus(&1, bus_ids))
    |> output(earliest)
  end

  def solve(2, [_, buses]), do: check_departure(buses, 1, 1) - length(buses) + 1

  defp check_departure([], time, _), do: time - 1
  defp check_departure([0 | tail], time, inc), do: check_departure(tail, time + 1, inc)

  defp check_departure([bus | tail] = buses, time, increment) do
    case rem(time, bus) do
      0 -> check_departure(tail, time + 1, increment * bus)
      _ -> check_departure(buses, time + increment, increment)
    end
  end

  defp output({time, bus_id}, earliest), do: bus_id * (time - earliest)

  defp find_departing_bus(time, bus_ids) do
    Enum.find_value(bus_ids, fn bus_id ->
      if rem(time, bus_id) == 0, do: {time, bus_id}
    end)
  end

  defp parse_bus_ids(bus_ids) do
    bus_ids
    |> String.split(",")
    |> Enum.map(fn
      "x" -> 0
      number -> String.to_integer(number)
    end)
  end
end
