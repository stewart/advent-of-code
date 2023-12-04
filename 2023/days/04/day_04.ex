defmodule Day4 do
  @moduledoc "Day 4: Scratchcards"
  import Advent

  datafile = Path.join(__DIR__, "data")
  @external_resource datafile
  @input File.read!(datafile) |> String.split("\n", trim: true)

  def input do
    import String, only: [to_integer: 1]

    for card <- @input do
      [_, card, lhs, rhs] =
        Regex.run(~r/^Card\s+(\d+):\s+([\s\d]+)\|([\s\d]+)$/, card)

      lhs =
        for n <- String.split(lhs, ~r/\s+/, trim: true),
            do: to_integer(n)

      rhs =
        for n <- String.split(rhs, ~r/\s+/, trim: true),
            do: to_integer(n)

      {to_integer(card), lhs, rhs}
    end
  end

  def part1 do
    count_points = fn {_, winning, having} ->
      case Enum.filter(having, & &1 in winning) do
        [] -> 0
        [_] -> 1
        [_ | points] -> Enum.reduce(points, 1, fn _, total -> total * 2 end)
      end
    end

    input()
    |> Enum.map(count_points)
    |> Enum.sum()
  end
end
