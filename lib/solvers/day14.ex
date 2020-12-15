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

  def solve(2, input) do
    input
    |> Enum.reduce(%{memory: %{}, mask: nil}, fn
      {:mask, mask}, acc -> put_in(acc.mask, mask)
      {:mem, {address, value}}, acc -> put_in(acc.memory, store_with_mask(acc, address, value))
    end)
    |> Map.fetch!(:memory)
    |> Map.values()
    |> Enum.sum()
  end

  defp store_with_mask(acc, address, value) do
    address
    |> Integer.to_string(2)
    |> String.pad_leading(36, "0")
    |> String.graphemes()
    |> Enum.reverse()
    |> Enum.zip(Enum.reverse(String.graphemes(acc.mask)))
    |> enum_addresses()
    |> Enum.reduce(acc.memory, fn address, memory -> Map.put(memory, address, value) end)
  end

  defp enum_addresses(parts, passed \\ [])
  defp enum_addresses([], passed), do: [Enum.join(passed)]

  defp enum_addresses([{address, mask} | tail], passed) do
    case mask do
      "0" -> enum_addresses(tail, [address | passed])
      "1" -> enum_addresses(tail, ["1" | passed])
      "X" -> enum_addresses(tail, ["0" | passed]) ++ enum_addresses(tail, ["1" | passed])
    end
  end

  defp apply_mask(mask, number) do
    number
    |> Bitwise.band(mask |> String.replace("X", "1") |> String.to_integer(2))
    |> Bitwise.bor(mask |> String.replace("X", "0") |> String.to_integer(2))
  end

  defp parse_line("mask = " <> mask), do: {:mask, String.pad_leading(mask, 36, "0")}
  defp parse_line("mem[" <> mem), do: {:mem, parse_mem(mem)}

  defp parse_mem(mem) do
    [location, value] = String.split(mem, "] = ")
    {String.to_integer(location), String.to_integer(value)}
  end
end
