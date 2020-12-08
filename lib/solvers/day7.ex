defmodule Aoc.Solvers.Day7 do
  @behaviour Aoc.Solver

  @impl Aoc.Solver
  def parse_input(input) do
    input
    |> String.replace(".", "")
    |> String.split("\n")
    |> Enum.map(&parse_rule/1)
    |> Enum.reduce(Graph.new(), &compile_graph/2)
  end

  @impl Aoc.Solver
  def solve(1, input) do
    input
    |> Graph.reaching(["shiny gold"])
    |> List.delete("shiny gold")
    |> length()
  end

  def solve(2, graph) do
    count_bag(graph, "shiny gold") - 1
  end

  defp count_bag(graph, bag) do
    count_inner_bags(graph, bag) + 1
  end

  defp count_inner_bags(graph, bag) do
    graph
    |> Graph.out_edges(bag)
    |> Stream.map(fn %Graph.Edge{v2: bag, weight: number} -> number * count_bag(graph, bag) end)
    |> Enum.sum()
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
