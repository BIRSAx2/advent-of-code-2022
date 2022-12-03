defmodule AdventOfCode.Day03 do
  defp parse_part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split_at(div(String.length(line), 2))
      |> Tuple.to_list()
    end)
  end

  defp priority(char) when char in ?a..?z do
    -96 + char
  end

  defp priority(char) when char in ?A..?Z do
    -38 + char
  end

  defp string_to_mapset(string) do
    string
    |> String.graphemes()
    |> MapSet.new()
  end

  def find_common_item(rucksacks) do
    set =
      rucksacks
      |> Enum.at(0)
      |> string_to_mapset()

    rucksacks
    |> Enum.drop(1)
    |> Enum.reduce(set, fn rucksack, acc ->
      rucksack
      |> string_to_mapset()
      |> MapSet.intersection(acc)
    end)
    |> MapSet.to_list()
    |> hd()
    |> String.to_charlist()
    |> hd
  end

  def part1(args) do
    parse_part1(args)
    |> Enum.map(&find_common_item/1)
    |> Enum.map(&priority/1)
    |> Enum.sum()
  end

  def parse_part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.chunk_every(3)
  end

  def part2(args) do
    parse_part2(args)
    |> Enum.map(&find_common_item/1)
    |> Enum.map(&priority/1)
    |> Enum.sum()
  end
end
