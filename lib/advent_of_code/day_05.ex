defmodule AdventOfCode.Day05 do
  defp parse(args) do
    [crates, moves] = String.split(args, "\n\n")

    parsed_crates =
      crates
      |> String.split("\n")
      |> Enum.map(fn line ->
        line
        |> String.graphemes()
        |> Enum.drop_every(2)
        |> Enum.with_index()
        |> Enum.filter(fn {char, _} -> char != " " end)
      end)
      |> Enum.filter(&(not Enum.empty?(&1)))
      # starting from the bottom
      |> Enum.reverse()
      |> List.flatten()
      |> Enum.reduce(%{}, fn {item, index}, acc ->
        Map.update(acc, div(index, 2), [item], fn old -> [item | old] end)
      end)

    parsed_moves =
      moves
      |> String.split("\n", trim: true)
      |> Enum.map(fn move ->
        move
        |> String.split(~r/[^\d]+/, trim: true)
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()
        |> then(fn {count, from, to} -> {count, from - 1, to - 1} end)
      end)

    [parsed_crates, parsed_moves]
  end

  defp move_crate(crates, {0, _, _}), do: crates

  defp move_crate(crates, {count, from, to}) do
    [to_move | rest] = Map.get(crates, from)

    crates
    |> Map.put(from, rest)
    |> Map.update!(to, fn present -> [to_move | present] end)
    |> then(&move_crate(&1, {count - 1, from, to}))
  end

  defp move_crate_in_order(crates, {count, from, to}) do
    to_move = Map.get(crates, from) |> Enum.take(count)
    remaining = Map.get(crates, from) |> Enum.drop(count)

    crates
    |> Map.put(from, remaining)
    |> Map.update!(to, fn present -> to_move ++ present end)
  end

  defp get_top_crates(crates) do
    crates
    |> Map.values()
    |> Enum.map(&hd/1)
  end

  def part1(args) do
    [crates, moves] = parse(args)

    moves
    |> Enum.reduce(crates, fn move, crates ->
      move_crate(crates, move)
    end)
    |> get_top_crates()
    |> Enum.join()
  end

  def part2(args) do
    [crates, moves] = parse(args)

    moves
    |> Enum.reduce(crates, fn move, crates ->
      move_crate_in_order(crates, move)
    end)
    |> get_top_crates()
    |> Enum.join()
  end
end
