defmodule Aoc.Solvers.Day8 do
  alias Aoc.Handheld

  @behaviour Aoc.Solver

  @impl Aoc.Solver
  def parse_input(input) do
    Handheld.new(input)
  end

  @impl Aoc.Solver
  def solve(1, input) do
    input
    |> Handheld.run()
    |> elem(1)
  end

  def solve(2, input) do
    input
    |> Handheld.get_program()
    |> Stream.filter(&is_jmp_or_nop/1)
    |> Stream.map(fn {address, inst} -> {address, swap_jmp_nop(inst)} end)
    |> Stream.map(&try_fixing(input, &1))
    |> Enum.find(&is_fixed?/1)
    |> Handheld.run()
    |> elem(1)
  end

  defp is_jmp_or_nop({_, {type, _}}), do: type in ["jmp", "nop"]
  defp swap_jmp_nop({"jmp", arg}), do: {"nop", arg}
  defp swap_jmp_nop({"nop", arg}), do: {"jmp", arg}
  defp try_fixing(handheld, {address, inst}), do: Handheld.update_program(handheld, address, inst)
  defp is_fixed?(handheld), do: match?({:completed, _}, Handheld.run(handheld))
end
