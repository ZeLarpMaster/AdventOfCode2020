defmodule Aoc.Solvers.Day16 do
  @behaviour Aoc.Solver

  @impl Aoc.Solver
  def parse_input(input) do
    input
    |> String.split("\n\n")
    |> parse_input_sections()
  end

  @impl Aoc.Solver
  def solve(1, input) do
    input.rules
    |> flatten_rules()
    |> extract_invalid_values(input.tickets)
    |> Enum.sum()
  end

  def solve(2, input) do
    flat_rules = flatten_rules(input.rules)

    transposed =
      input.tickets
      |> Enum.filter(fn ticket -> Enum.all?(ticket, &MapSet.member?(flat_rules, &1)) end)
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)

    input.rules
    |> map_fields(Enum.with_index(transposed), [])
    |> Enum.map(fn {{key, _, _}, {_, column_index}} -> {key, column_index} end)
    |> Enum.map(fn {key, column_index} -> {key, Enum.at(input.my_ticket, column_index)} end)
    |> Enum.filter(fn {key, _value} -> String.starts_with?(key, "departure ") end)
    |> Enum.map(fn {_key, value} -> value end)
    |> Enum.reduce(&Kernel.*/2)
  end

  defp map_fields(_rules, [], out), do: out

  defp map_fields(rules, columns, out) do
    # Find the rule which has only one valid column
    {rule, column} =
      Enum.find_value(rules, fn rule ->
        valid_columns = Enum.filter(columns, fn {column, _index} -> all_valid?(rule, column) end)
        if length(valid_columns) == 1, do: {rule, List.first(valid_columns)}
      end)

    # Remove the rule and its column and keep going
    map_fields(List.delete(rules, rule), List.delete(columns, column), [{rule, column} | out])
  end

  defp all_valid?(rule, column), do: Enum.all?(column, &is_valid?(rule, &1))
  defp is_valid?({_key, range1, range2}, number), do: number in range1 or number in range2

  defp extract_invalid_values(valid_values, tickets) do
    Enum.reduce(tickets, [], fn ticket, list ->
      Enum.reject(ticket, &MapSet.member?(valid_values, &1)) ++ list
    end)
  end

  defp flatten_rules(rules) do
    rules
    |> Enum.map(fn {_key, range1, range2} ->
      MapSet.union(MapSet.new(range1), MapSet.new(range2))
    end)
    |> Enum.reduce(&MapSet.union/2)
  end

  defp parse_input_sections([rules, "your ticket:" <> my_ticket, tickets]) do
    %{
      rules: parse_rules(rules),
      my_ticket: parse_ticket(my_ticket),
      tickets: parse_tickets(tickets)
    }
  end

  defp parse_rules(rules) do
    rules
    |> String.split("\n")
    |> Enum.map(&parse_rule/1)
  end

  defp parse_rule(rule) do
    [key, values] = String.split(rule, ": ")
    [range1, range2] = String.split(values, " or ")
    {key, parse_range(range1), parse_range(range2)}
  end

  defp parse_range(range) do
    [start, finish] = String.split(range, "-")
    String.to_integer(start)..String.to_integer(finish)
  end

  defp parse_tickets("nearby tickets:" <> tickets) do
    tickets
    |> String.trim()
    |> String.split()
    |> Enum.map(&parse_ticket/1)
  end

  defp parse_ticket(ticket) do
    ticket
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end
