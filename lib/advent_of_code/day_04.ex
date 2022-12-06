defmodule AdventOfCode.Day04 do
  defp parse(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn pair ->
      pair
      |> String.split(~r/,|-/)
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)
      |> Enum.map(fn [start, finish] -> start..finish end)
    end)
  end

  defp overlaps(a1..a2, b1..b2) do
    (a1 >= b1 && a2 <= b2) ||
      (b1 >= a1 && b2 <= a2)
  end

  defp find_overlapping_pairs(pairs, criteria) do
    pairs
    |> Enum.filter(fn [a, b] -> criteria.(a, b) end)
  end

  def part1(args) do
    args
    |> parse()
    |> find_overlapping_pairs(&overlaps/2)
    |> length()
  end

  def part2(args) do
    args
    |> parse()
    |> find_overlapping_pairs(fn a, b -> !Range.disjoint?(a, b) end)
    |> length()
  end
end
