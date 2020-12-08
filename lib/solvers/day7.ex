defmodule Aoc.Solvers.Day7 do
  @behaviour Aoc.Solver

  @impl Aoc.Solver
  @spec parse_input(String.t()) :: Graph.t()
  def parse_input(input) do
    input
    |> String.replace(".", "")
    |> String.split("\n")
    |> Enum.map(&parse_rule/1)
    |> Enum.reduce(Graph.new(), &compile_graph/2)
  end

  @impl Aoc.Solver
  @spec solve(1 | 2, Graph.t()) :: any
  def solve(1, input) do
    input
    |> Graph.reaching(["shiny gold"])
    |> List.delete("shiny gold")
    |> length()
  end

  defp parse_rule(rule) do
    [bag, bags] = String.split(rule, " contain ")
    {parse_bag(bag), parse_bags(bags)}
  end

  defp parse_bags("no other bags"), do: []
  defp parse_bags(bags), do: Enum.map(String.split(bags, ", "), &parse_bag_count/1)

  defp parse_bag_count(bag) do
    [number, bag] = String.split(bag, " ", parts: 2)
    {String.to_integer(number), parse_bag(bag)}
  end

  defp parse_bag(bag) do
    bag
    |> String.replace_suffix(" bags", "")
    |> String.replace_suffix(" bag", "")
  end

  # Graph points towards bags which don't contain any other bags
  defp compile_graph({bag, bags}, graph) do
    Graph.add_edges(graph, convert_bags_to_edge(bag, bags))
  end

  defp convert_bags_to_edge(bag, bags) do
    Enum.map(bags, fn {number, inner_bag} ->
      {bag, inner_bag, weight: number}
    end)
  end
end
