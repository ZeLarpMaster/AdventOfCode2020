defmodule Aoc.Solvers.Day15.Rust do
  use Rustler, otp_app: :aoc, crate: :aoc_solvers_day15_rust

  # When your NIF is loaded, it will override this function.
  def start_speaking(_input, _max_turns), do: :erlang.nif_error(:nif_not_loaded)
end
