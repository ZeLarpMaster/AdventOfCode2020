defmodule Aoc.KnownAnswer do
  @moduledoc "Extracts known answers from their files"

  @spec get_answer(pos_integer, 1 | 2) :: String.t() | nil
  def get_answer(day, part) do
    "known_answers/day#{day}.txt"
    |> File.read!()
    |> String.trim()
    |> String.split()
    |> Enum.at(part - 1)
  end
end
