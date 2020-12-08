defmodule Aoc.Handheld do
  @moduledoc false

  # program: A map of instructions by address
  # psize: Program Size
  # pc: Program Counter
  # fi: Fetched Instruction
  # acc: Accumulator
  # seen: Instructions seen
  defstruct [:program, :psize, pc: 0, fi: nil, acc: 0, seen: MapSet.new()]

  @type inst :: {String.t(), integer()}
  @type program :: %{optional(non_neg_integer) => inst()}

  @type t :: %__MODULE__{
          program: program(),
          psize: non_neg_integer,
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

  @spec get_program(t()) :: program()
  def get_program(handheld), do: handheld.program

  @spec update_program(t(), non_neg_integer, inst()) :: t()
  def update_program(handheld, address, new_inst), do: put_in(handheld.program[address], new_inst)

  @spec run(t()) :: {:looped | :completed, integer}
  def run(handheld) do
    cond do
      has_looped?(handheld) ->
        {:looped, get_acc(handheld)}

      has_completed?(handheld) ->
        {:completed, get_acc(handheld)}

      true ->
        handheld
        |> record_seen()
        |> load()
        |> execute()
        |> increment_pc()
        |> run()
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

  defp has_looped?(handheld), do: MapSet.member?(handheld.seen, handheld.pc)
  defp has_completed?(handheld), do: handheld.pc >= handheld.psize

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
  defp get_psize(program), do: Enum.max(Map.keys(program)) + 1
  defp from_program(program), do: %__MODULE__{program: program, psize: get_psize(program)}
end
