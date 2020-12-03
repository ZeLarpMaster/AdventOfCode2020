defmodule Aoc.Input do
  @moduledoc "Facilitates the usage of input files"

  @doc "Fetches the raw content of the day's input"
  @spec get_raw(pos_integer) :: String.t()
  def get_raw(day) do
    File.read!("inputs/day#{day}.txt") |> String.trim()
  end
end
