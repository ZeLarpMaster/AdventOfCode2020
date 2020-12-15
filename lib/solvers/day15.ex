defmodule Aoc.Solvers.Day15 do
  @behaviour Aoc.Solver

  @impl Aoc.Solver
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  @impl Aoc.Solver
  def solve(1, input), do: start_speaking(input, 2020)
  def solve(2, input), do: start_speaking(input, 30_000_000)

  defp start_speaking(input, max_turn) do
    speak(0, Map.new(Enum.with_index(input, 1)), length(input) + 1, max_turn)
  end

  defp speak(number, _, turn, max_turn) when turn == max_turn, do: number

  defp speak(number, spoken_map, turn, max_turn) do
    last_spoken = Map.get(spoken_map, number)
    spoken_map = Map.put(spoken_map, number, turn)

    if last_spoken == nil do
      0
    else
      turn - last_spoken
    end
    |> speak(spoken_map, turn + 1, max_turn)
  end
end
