defmodule Aoc.Solvers.Day14 do
  @behaviour Aoc.Solver

  @impl Aoc.Solver
  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  @impl Aoc.Solver
  def solve(1, input) do
    input
    |> Enum.reduce(%{memory: %{}, mask: nil}, fn
      {:mask, mask}, acc -> put_in(acc.mask, mask)
      {:mem, {address, value}}, acc -> put_in(acc.memory[address], apply_mask(acc.mask, value))
    end)
    |> Map.fetch!(:memory)
    |> Map.values()
    |> Enum.sum()
  end

  defp apply_mask(mask, number) do
    number
    |> String.to_integer()
    |> Bitwise.band(mask |> String.replace("X", "1") |> String.to_integer(2))
    |> Bitwise.bor(mask |> String.replace("X", "0") |> String.to_integer(2))
  end

  defp parse_line("mask = " <> mask), do: {:mask, String.pad_leading(mask, 36, "0")}
  defp parse_line("mem[" <> mem), do: {:mem, parse_mem(mem)}

  defp parse_mem(mem) do
    [location, value] = String.split(mem, "] = ")
    {String.to_integer(location), value}
  end
end
