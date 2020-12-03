defmodule Aoc.Solvers.Day2 do
  @behaviour Aoc.Solver

  @impl Aoc.Solver
  def solve(1, input) do
    parse_input(input)
    |> Enum.count(&check_requirement/1)
  end

  defp check_requirement({min_count, max_count, letter, password}) do
    Enum.count(String.graphemes(password), fn char -> char == letter end) in min_count..max_count
  end

  # Line example: 1-10 a: aaabbbcccddee
  defp parse_line(line) do
    [counts, letter, password] = String.split(line)
    [min_count, max_count] = String.split(counts, "-")

    {
      String.to_integer(min_count),
      String.to_integer(max_count),
      String.trim(letter, ":"),
      password
    }
  end

  defp parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end
end
