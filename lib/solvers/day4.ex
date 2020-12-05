defmodule Aoc.Solvers.Day4 do
  @behaviour Aoc.Solver

  @keys [
    :byr, # Birth Year
    :iyr, # Issue Year
    :eyr, # Expiration Year
    :hgt, # Height
    :hcl, # Hair Color
    :ecl, # Eye Color
    :pid, # Passport ID
    :cid  # Country ID
  ]

  @required_keys List.delete(@keys, :cid)

  @impl Aoc.Solver
  def parse_input(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(&parse_passport/1)
  end

  @impl Aoc.Solver
  def solve(1, input) do
    input
    |> Enum.count(&check_valid/1)
  end

  def check_valid(passport) do
    Enum.all?(@required_keys, &Map.has_key?(passport, &1))
  end

  defp parse_passport(passport) do
    passport
    |> String.split()
    |> Enum.map(&parse_keyvalue/1)
    |> Map.new()
  end

  defp parse_keyvalue(word) do
    [key, value] = String.split(word, ":")
    {String.to_atom(key), value}
  end
end
