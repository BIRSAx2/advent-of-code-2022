defmodule AdventOfCode.Day02 do
  defp calculate_outcome(rounds) do
    rounds
    |> Enum.map(fn [opponent, player] ->
      player =
        case player do
          "X" -> :rock
          "Y" -> :paper
          "Z" -> :scissors
        end

      losing_against =
        case opponent do
          :rock -> :paper
          :paper -> :scissors
          :scissors -> :rock
        end

      cond do
        opponent == player -> {:draw, player}
        player == losing_against -> {:win, player}
        true -> {:loss, player}
      end
    end)
  end

  defp parse(args) do
    moves = %{
      "A" => :rock,
      "B" => :paper,
      "C" => :scissors
    }

    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn round ->
      round
      |> String.split(" ", trim: true)
      |> Enum.map(&Map.get(moves, &1, &1))
    end)
  end

  defp calculate_points({outcome, move}) do
    points_per_move = %{
      :rock => 1,
      :paper => 2,
      :scissors => 3
    }

    outcome_points = %{
      :win => 6,
      :draw => 3,
      :loss => 0
    }

    Map.get(outcome_points, outcome) + Map.get(points_per_move, move)
  end

  defp decide_move(rounds) do
    expected_outcome = %{
      "X" => :loss,
      "Y" => :draw,
      "Z" => :win
    }

    wins = %{
      :rock => :paper,
      :paper => :scissors,
      :scissors => :rock
    }

    loss = %{
      :paper => :rock,
      :scissors => :paper,
      :rock => :scissors
    }

    rounds
    |> Enum.map(fn [opponent, outcome] ->
      outcome = Map.get(expected_outcome, outcome)

      case outcome do
        :draw -> {:draw, opponent}
        :loss -> {:loss, Map.get(loss, opponent)}
        :win -> {:win, Map.get(wins, opponent)}
      end
    end)
  end

  def part1(args) do
    parse(args)
    |> calculate_outcome()
    |> Enum.map(&calculate_points/1)
    |> Enum.sum()
  end

  def part2(args) do
    parse(args)
    |> decide_move()
    |> Enum.map(&calculate_points/1)
    |> Enum.sum()
  end
end
