defmodule Aoc.Handheld do
  @moduledoc false

  # program: A map of instructions by address
  # pc: Program Counter
  # fi: Fetched Instruction
  # acc: Accumulator
  # seen: Instructions seen
  defstruct [:program, pc: 0, fi: nil, acc: 0, seen: MapSet.new()]

  @type inst :: {String.t(), integer()}

  @type t :: %__MODULE__{
          program: %{optional(non_neg_integer) => inst()},
          pc: non_neg_integer,
          fi: inst() | nil,
          acc: integer,
          seen: MapSet.t(non_neg_integer)
        }

  @spec new(String.t()) :: t()
  def new(program) do
    program
    |> String.split("\n")
    |> Enum.map(&parse_instruction/1)
    |> Enum.with_index()
    |> Enum.map(fn {instruction, index} -> {index, instruction} end)
    |> Map.new()
    |> from_program()
  end

  @spec has_looped?(t()) :: boolean
  def has_looped?(handheld), do: MapSet.member?(handheld.seen, handheld.pc)

  @spec run_until_loop(t()) :: integer
  def run_until_loop(handheld) do
    if has_looped?(handheld) do
      get_acc(handheld)
    else
      handheld
      |> record_seen()
      |> load()
      |> execute()
      |> increment_pc()
      |> run_until_loop()
    end
  end

  # ===== START OF INSTRUCTIONS ======
  defp execute(handheld), do: execute(handheld.fi, handheld)

  defp execute(nil, _handheld), do: raise("Tried to execute a nil instruction")

  # ACCumulate; acc <- acc + arg
  defp execute({"acc", arg}, handheld), do: increment_acc(handheld, arg)

  # No OPeration; do nothing
  defp execute({"nop", _}, handheld), do: handheld

  # JuMP; pc <- pc + arg
  defp execute({"jmp", diff}, handheld), do: increment_pc(handheld, diff - 1)

  # ===== END OF INSTRUCTIONS =====

  defp parse_instruction(line) do
    [inst, arg] = String.split(line)
    {inst, String.to_integer(arg)}
  end

  defp get_instruction(handheld), do: Map.fetch!(handheld.program, handheld.pc)
  defp load(handheld), do: put_in(handheld.fi, get_instruction(handheld))
  defp get_acc(handheld), do: handheld.acc
  defp record_seen(handheld), do: update_in(handheld.seen, &MapSet.put(&1, handheld.pc))
  defp increment_acc(handheld, value), do: update_in(handheld.acc, &(&1 + value))
  defp increment_pc(handheld, value \\ 1), do: update_in(handheld.pc, &(&1 + value))
  defp from_program(program), do: %__MODULE__{program: program}
end
