defmodule Aoc.Solvers.Day4 do
  @behaviour Aoc.Solver

  @keys ~w(byr iyr eyr hgt hcl ecl pid cid)a
  @required_keys List.delete(@keys, :cid)
  @valid_eye_colors ~w(amb blu brn gry grn hzl oth)

  @impl Aoc.Solver
  def parse_input(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(&parse_passport/1)
  end

  @impl Aoc.Solver
  def solve(1, input), do: Enum.count(input, &check_valid/1)
  def solve(2, input), do: Enum.count(input, &check_valid_values/1)

  defp check_valid_values(passport) do
    Enum.all?(@required_keys, &check_valid_value(&1, Map.get(passport, &1)))
  end

  defp check_valid(passport) do
    Enum.all?(@required_keys, &Map.has_key?(passport, &1))
  end

  defp check_valid_value(key, nil), do: key not in @required_keys
  defp check_valid_value(:byr, value), do: check_range(value, 1920..2002)
  defp check_valid_value(:iyr, value), do: check_range(value, 2010..2020)
  defp check_valid_value(:eyr, value), do: check_range(value, 2020..2030)
  defp check_valid_value(:hgt, value), do: check_height(value)
  defp check_valid_value(:hcl, "#" <> value), do: check_hexa(value)
  defp check_valid_value(:ecl, value), do: value in @valid_eye_colors
  defp check_valid_value(:pid, value), do: check_passport_id(value)
  defp check_valid_value(_key, _value), do: false

  defp check_passport_id(value) do
    is_number = match?({_, ""}, Integer.parse(value))
    String.length(value) == 9 and is_number
  end

  defp check_hexa(value) do
    is_only_hexa = match?({_, ""}, Integer.parse(value, 16))
    String.length(value) == 6 and is_only_hexa
  end

  defp check_height(value) do
    {height, unit} = String.split_at(value, -2)

    case unit do
      "cm" -> check_range(height, 150..193)
      "in" -> check_range(height, 59..76)
      _ -> false
    end
  end

  defp check_range(value, range) do
    case Integer.parse(value) do
      {int, ""} -> int in range
      _ -> false
    end
  end

  defp parse_passport(passport) do
    passport
    |> String.split()
    |> Enum.map(&String.split(&1, ":"))
    |> Enum.map(fn [key, value] -> {String.to_atom(key), value} end)
    |> Map.new()
  end
end
