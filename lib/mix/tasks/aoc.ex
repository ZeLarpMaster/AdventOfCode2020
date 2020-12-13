defmodule Mix.Tasks.Aoc do
  @moduledoc """
  Mix task for running the solution for a given AdventOfCode challenge.

  The task can be called as follows:
  `mix aoc day [part] [--test data]`
  * `day` is the day for which to run the solution
  * `[part]` is the part of the day for which to run the solution (default: 1)
  * `[--test data]` is used for passing test data to the solver. If not present, the corresponding input file is used instead.
  * `[--profile]` runs the given code with a profiler and outputs the profiling data in the console
  """

  use Mix.Task

  import Aoc.Input
  import ExProf.Macro

  @spec run([any]) :: :ok
  def run(argv) do
    {switches, args} = OptionParser.parse!(argv, strict: [test: :string, profile: :boolean])
    run_task(args, switches)
  end

  defp run_task([], _switches), do: IO.puts("Missing required argument <day>")
  defp run_task([day], switches), do: run_task([day, "1"], switches)
  defp run_task([_, part], _) when part not in ["1", "2"], do: IO.puts("Invalid part: #{part}")

  defp run_task([day, part], switches) do
    day = String.to_integer(day)
    part = String.to_integer(part)

    data =
      if Keyword.has_key?(switches, :test),
        do: switches |> Keyword.fetch!(:test) |> String.replace("\\n", "\n")

    if Keyword.get(switches, :profile, false) do
      profile do
        run_day_part(day, part, data)
      end
    else
      run_day_part(day, part, data)
    end
  end

  defp run_day_part(day, part, data) do
    IO.puts("\nExecuting day #{day}, part #{part}\n")
    input = data || get_raw(day)
    output = solve(day, part, String.trim(input))
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
