defmodule AdventOfCode.Day07 do
  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> parse([], [])
  end

  defp parse(["$ cd .." | tail], [cwd, parent | parents], acc) do
    parse(tail, [cwd + parent | parents], [cwd | acc])
  end

  defp parse(["$ cd " <> _ | tail], parents, acc) do
    parse(tail, [0 | parents], acc)
  end

  # Skip these
  defp parse(["$ ls" | tail], parents, acc), do: parse(tail, parents, acc)
  defp parse(["dir " <> _ | tail], parents, acc), do: parse(tail, parents, acc)

  defp parse([file | tail], [cwd | parents], acc) do
    [fsize, _] = String.split(file)
    parse(tail, [cwd + String.to_integer(fsize) | parents], acc)
  end

  defp parse([], [], acc), do: acc
  defp parse([], [root], acc), do: [root | acc]

  defp parse([], [cwd, parent | parents], acc) do
    parse([], [cwd + parent | parents], [cwd | acc])
  end

  def part1(args) do
    args
    |> parse()
    |> Enum.filter(&(&1 <= 100_000))
    |> Enum.sum()
  end

  def part2(args) do
    total_disk_space = 70_000_000
    needed_space = 30_000_000

    [root | children] = parse(args)

    to_free = root - (total_disk_space - needed_space)

    children
    |> Enum.filter(&(&1 >= to_free))
    |> Enum.min()
  end
end
