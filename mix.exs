defmodule Aoc.MixProject do
  use Mix.Project

  def project do
    [
      app: :aoc,
      version: "0.1.0",
      elixir: "~> 1.10",
      compilers: [:rustler] ++ Mix.compilers(),
      rustler_crates: rustler_crates(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:rustler, "~> 0.21.1"},
      {:libgraph, "~> 0.13"},
      {:exprof, "~> 0.2.3"},
      {:credo, "~> 1.5", only: [:dev], runtime: false}
    ]
  end

  defp rustler_crates do
    [
      aoc_solvers_day15_rust: []
    ]
  end
end
