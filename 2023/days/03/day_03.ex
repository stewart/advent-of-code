defmodule Day03 do
  @moduledoc false
  import Advent

  datafile = Path.join(__DIR__, "data")
  @external_resource datafile
  @input datafile |> File.read!() |> String.split("\n", trim: true)

  def input do
    @input
  end

  def part1 do
    parts =
      for {line, y} <- Enum.with_index(input()),
          {char, x} <- Enum.with_index(String.graphemes(line)),
          char =~ ~r/[^.\d]/,
          into: %{},
          do: {{x, y}, char}

    numbers =
      for {line, y} <- Enum.with_index(input()),
          [{x, length}] <- Regex.scan(~r[\d+], line, return: :index),
          number = String.to_integer(binary_part(line, x, length)),
          into: %{},
          do: {{x, y, length}, number}

    is_part_number? = fn {{x, y, length}, _} ->
      adjacents = for mx <- -1..length, my <- -1..1, do: {x + mx, y + my}
      Enum.any?(adjacents, &Map.has_key?(parts, &1))
    end

    numbers
    |> Enum.filter(is_part_number?)
    |> Enum.map(fn {_, n} -> n end)
    |> Enum.sum()
  end

  def part2 do
    parts =
      for {line, y} <- Enum.with_index(input()),
          {char, x} <- Enum.with_index(String.graphemes(line)),
          char =~ ~r/[^.\d]/,
          into: %{},
          do: {{x, y}, char}

    numbers =
      for {line, y} <- Enum.with_index(input()),
          [{start, length}] <- Regex.scan(~r[\d+], line, return: :index),
          number = String.to_integer(binary_part(line, start, length)),
          x <- start..start+(length - 1),
          into: %{},
          do: {{x, y}, number}

    to_gear_ratio = fn {{x, y}, symbol} ->
      if symbol == "*" do
        adjacent_numbers =
          for x <- (x-1)..(x+1),
              y <- (y-1)..(y+1),
              n = numbers[{x, y}],
              uniq: true,
              do: n

        if length(adjacent_numbers) == 2 do
          [gear_one, gear_two] = adjacent_numbers
          gear_one * gear_two
        end
      end
    end

    parts
    |> Enum.map(to_gear_ratio)
    |> Enum.reject(&is_nil/1)
    |> Enum.sum()
  end
end
