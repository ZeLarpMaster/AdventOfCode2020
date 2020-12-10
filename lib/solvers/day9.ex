defmodule Aoc.Solvers.Day9 do
  @behaviour Aoc.Solver

  @preamble_size 25

  @impl Aoc.Solver
  def parse_input(input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  @impl Aoc.Solver
  def solve(1, input) do
    preamble = Enum.take(input, @preamble_size)
    leftover = Enum.drop(input, @preamble_size)

    find_invalid(preamble, leftover)
  end

  def solve(2, input) do
    invalid_number = solve(1, input)
    sub_array = find_contiguous(input, invalid_number)
    Enum.min(sub_array) + Enum.max(sub_array)
  end

  defp find_contiguous(input, target) do
    Enum.reduce(input, {0, :queue.new()}, fn element, acc ->
      process_value(element, acc, target)
    end)
  catch
    {_sum, queue} -> :queue.to_list(queue)
  end

  defp process_value(element, {sum, queue}, target) do
    cond do
      element > target and :queue.is_empty(queue) -> {sum, queue}
      element + sum > target -> process_value(element, pop({sum, queue}), target)
      element + sum == target -> throw(push(element, {sum, queue}))
      true -> push(element, {sum, queue})
    end
  end

  defp pop({sum, queue}) do
    case :queue.out(queue) do
      {:empty, queue} -> {0, queue}
      {{:value, value}, queue} -> {sum - value, queue}
    end
  end

  defp push(value, {sum, queue}) do
    {sum + value, :queue.in(value, queue)}
  end

  defp find_invalid(_, []), do: "Nothing found :("

  defp find_invalid(list, [value | values]) do
    if check_value(MapSet.new(list), value) do
      new_list = tl(list) ++ [value]
      find_invalid(new_list, values)
    else
      value
    end
  end

  defp check_value(set, value) do
    Enum.any?(set, fn v -> MapSet.member?(set, value - v) end)
  end
end
