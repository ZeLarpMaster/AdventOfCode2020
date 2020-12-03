defmodule Mix.Tasks.Aoc do
  @moduledoc """
  Mix task for running the solution for a given AdventOfCode challenge.

  The task can be called as follows:
  `mix aoc day [part] [--test data]`
  * `day` is the day for which to run the solution
  * `[part]` is the part of the day for which to run the solution (default: 1)
  * `[--test data]` is used for passing test data to the solver. If not present, the corresponding input file is used instead.
  """

  use Mix.Task

  import Aoc.Input

  @spec run([any]) :: :ok
  def run([day]) do
    run([day, "1"])
  end

  def run([day, part]) do
    if Enum.member?(["1", "2"], part) do
      run_day_part(day, part)
    else
      IO.puts("Invalid part value: #{part}")
    end
  end

  def run([day, "--test", data]) do
    run([day, "1", "--test", String.replace(data, "\\n", "\n")])
  end

  def run([day, part, "--test", data]) do
    run_day_part(day, part, String.replace(data, "\\n", "\n"))
  end

  def run([]) do
    IO.puts("Missing required argument <day>")
  end

  defp run_day_part(day, part, data \\ nil) do
    IO.puts("\nExecuting day #{day}, part #{part}\n")
    input = data || get_raw(day)
    {part_int, ""} = Integer.parse(part)
    output = solve(day, part_int, input)
    IO.puts("Output for day #{day}\n#{output}")
  end

  defp solve(day, part, input) do
    before_time = :os.system_time(:microsecond)
    result = Aoc.Solver.solve(day, part, input)
    after_time = :os.system_time(:microsecond)

    IO.puts("\nExecution time: #{after_time - before_time}µs")

    result
  end
end
