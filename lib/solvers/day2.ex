defmodule Aoc.Solvers.Day2 do
  @behaviour Aoc.Solver

  @impl Aoc.Solver
  def solve(1, input) do
    parse_input(input)
    |> Enum.count(&check_count_requirement/1)
  end

  def solve(2, input) do
    parse_input(input)
    |> Enum.count(&check_position_requirement/1)
  end

  defp check_count_requirement({min_count, max_count, letter, password}) do
    Enum.count(String.graphemes(password), fn char -> char == letter end) in min_count..max_count
  end

  defp check_position_requirement({pos1, pos2, letter, password}) do
    check1 = String.at(password, pos1 - 1) == letter
    check2 = String.at(password, pos2 - 1) == letter

    case {check1, check2} do
      {false, false} -> false
      {false, true} -> true
      {true, false} -> true
      {true, true} -> false
    end
  end

  # Line example: 1-10 a: aaabbbcccddee
  defp parse_line(line) do
    [numbers, letter, password] = String.split(line)
    [first_num, second_num] = String.split(numbers, "-")

    {
      String.to_integer(first_num),
      String.to_integer(second_num),
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
