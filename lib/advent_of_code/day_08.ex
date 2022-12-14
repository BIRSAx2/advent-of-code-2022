defmodule AdventOfCode.Day08 do
  # @offsets [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]
  def parse(args) do
    trees =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(fn row ->
        row
        |> String.graphemes()
        |> Enum.map(&String.to_integer/1)
      end)
      |> then(fn rows ->
        for {line, row} <- Enum.with_index(rows),
            {height, col} <- Enum.with_index(line),
            into: %{} do
          {{row, col}, height}
        end
      end)

    max_height =
      Map.keys(trees)
      |> Enum.max_by(fn {x, _y} -> x end)
      |> then(fn {x, _y} -> x end)

    max_width =
      Map.keys(trees)
      |> Enum.max_by(fn {_x, y} -> y end)
      |> then(fn {_x, y} -> y end)

    %{trees: trees, max_width: max_width, max_height: max_height}
  end

  defp visible_from_left(%{trees: trees}, {{x, y}, height}) do
    0..(x - 1)
    |> Enum.all?(fn i ->
      Map.get(trees, {i, y}) < height
    end)
  end

  defp visible_from_up(%{trees: trees}, {{x, y}, height}) do
    0..(y - 1)
    |> Enum.all?(fn i -> Map.get(trees, {x, i}) < height end)
  end

  defp visible_from_right(%{trees: trees, max_width: max_width}, {{x, y}, height}) do
    (x + 1)..max_width
    |> Enum.all?(fn i -> Map.get(trees, {i, y}) < height end)
  end

  defp visible_from_bottom(%{trees: trees, max_height: max_height}, {{x, y}, height}) do
    (y + 1)..max_height
    |> Enum.all?(fn i -> Map.get(trees, {x, i}) < height end)
  end

  defp visible?(_, {{0, _}, _}), do: true
  defp visible?(_, {{_, 0}, _}), do: true
  defp visible?(%{max_width: max_width}, {{_, max_width}, _}), do: true
  defp visible?(%{max_height: max_height}, {{max_height, _}, _}), do: true

  defp visible?(grid, tree) do
    left = visible_from_left(grid, tree)

    right = visible_from_right(grid, tree)

    up = visible_from_up(grid, tree)

    down = visible_from_bottom(grid, tree)

    left || right || up || down
  end

  def part1(args) do
    grid = parse(args)

    grid
    |> Map.get(:trees)
    |> Map.to_list()
    |> Enum.map(fn tree ->
      visible?(grid, tree)
    end)
    |> Enum.count(& &1)
  end

  defp visiblity_horizontally(trees, {{_x, y}, height}, range) do
    range
    |> Enum.reduce_while(0, fn i, acc ->
      h = Map.get(trees, {i, y})
      if h < height, do: {:cont, acc + 1}, else: {:halt, acc + 1}
    end)
  end

  defp visibility_vertially(trees, {{x, _y}, height}, range) do
    range
    |> Enum.reduce_while(0, fn j, acc ->
      h = Map.get(trees, {x, j})
      if h < height, do: {:cont, acc + 1}, else: {:halt, acc + 1}
    end)
  end

  def calculate_scenic_score(
        %{trees: trees, max_height: max_height, max_width: max_width},
        {{x, y}, _} = tree
      ) do
    left = visiblity_horizontally(trees, tree, (x - 1)..0)
    right = visiblity_horizontally(trees, tree, (x + 1)..max_width)

    up = visibility_vertially(trees, tree, (y - 1)..0)
    down = visibility_vertially(trees, tree, (y + 1)..max_height)

    left * right * up * down
  end

  def part2(args) do
    grid = parse(args)

    grid
    |> find_best_scenic_score()
  end

  def find_best_scenic_score(grid = %{trees: trees, max_height: max_height, max_width: max_width}) do
    for i <- 1..(max_width - 1), j <- 1..(max_height - 1) do
      calculate_scenic_score(grid, {{i, j}, Map.get(trees, {i, j})})
    end
    |> Enum.max()
  end
end
