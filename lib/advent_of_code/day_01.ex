defmodule AdventOfCode.Day01 do
  defp parse(args) do
    args
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn calories ->
      calories
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp sum_each_elve_calories(calories) do
    calories
    |> Enum.map(&Enum.sum/1)
  end

  defp take_top_3(calories) do
    calories
    |> Enum.sort(&(&1 > &2))
    |> Enum.take(3)
  end

  def part1(args) do
    input = parse(args)

    input
    |> sum_each_elve_calories()
    |> Enum.max()
  end

  def part2(args) do
    args
    |> parse()
    |> sum_each_elve_calories()
    |> take_top_3()
    |> Enum.sum()
  end
end
