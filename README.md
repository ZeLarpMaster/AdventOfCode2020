# AoC
My solutions for the 2020 edition of [Advent of Code](https://adventofcode.com/)

## Usage
You must have Elixir installed to run this. You can use [asdf](https://asdf-vm.com) for that.

Run `mix aoc day [part] [--test data] [--profile]` where:
* `day` is the day for which to run the solution
* `[part]` is the part of the day for which to run the solution (default: 1)
* `[--test data]` is used for passing test data to the solver. If not present, the corresponding input file is used instead.
* `[--profile]` runs the given code with a profiler and outputs the profiling data in the console

## Tests
Alternatively, you may run `mix test` to run all days and all parts and verify that they all still give the right answer
