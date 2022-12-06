defmodule AdventOfCode.Day06 do
  defp parse(args) do
    args
    |> String.trim()
  end

  defp find_start_of_packet(signal, size \\ 4) do
    signal
    |> String.graphemes()
    |> Enum.chunk_every(size, 1, :discard)
    |> Enum.take_while(fn chunk ->
      Enum.uniq(chunk) != chunk
    end)
    |> length()
    |> then(&(&1 + size))
  end

  def part1(args) do
    args
    |> parse
    |> find_start_of_packet()
  end

  def part2(args) do
    args
    |> parse
    |> find_start_of_packet(14)
  end
end
