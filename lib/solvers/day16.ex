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
    |> Enum.map(fn {_key, range1, range2} ->
      MapSet.union(MapSet.new(range1), MapSet.new(range2))
    end)
    |> Enum.reduce(&MapSet.union/2)
    |> extract_invalid_values(input.tickets)
    |> Enum.sum()
  end

  defp extract_invalid_values(valid_values, tickets) do
    Enum.reduce(tickets, [], fn ticket, list ->
      Enum.reject(ticket, &MapSet.member?(valid_values, &1)) ++ list
    end)
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
