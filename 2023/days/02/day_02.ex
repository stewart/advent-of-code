defmodule Day02 do
  @moduledoc "Day 2: Cube Conundrum."
  import Advent

  datafile = Path.join(__DIR__, "data")
  @external_resource datafile
  @input datafile |> File.read!() |> String.split("\n", trim: true)

  def input do
    for line <- @input do
      [game | draws] = String.split(line, ~r/([:;])\s*/, trim: true)
      game_num = game |> String.trim_leading("Game ") |> String.to_integer()

      parsed_draws =
        for draw <- draws do
          for pick <- String.split(draw, ", ", trim: true) do
            {num, color} = Integer.parse(pick)
            {color |> String.trim() |> String.to_existing_atom(), num}
          end
        end

      {game_num, parsed_draws}
    end
  end

  def part1 do
    outside_limits = fn {_id, rounds} ->
      Enum.any?(rounds, fn round ->
        [red, green, blue] =
          for key <- [:red, :green, :blue],
            do: Keyword.get(round, key, 0)

        red > 12 or green > 13 or blue > 14
      end)
    end

    input()
    |> Enum.reject(outside_limits)
    |> Enum.map(fn {id, _} -> id end)
    |> Enum.sum()
  end

  def part2 do
    minimum_cubes_required = fn {id, rounds} ->
      Enum.reduce(rounds, %{}, fn round, acc ->
        Enum.reduce(round, acc, fn {color, count}, totals ->
          Map.update(totals, color, count, &max(&1, count))
        end)
      end)
    end

    calculate_power_level = fn cubes ->
      cubes |> Map.values() |> Enum.reduce(&Kernel.*/2)
    end

    input()
    |> Enum.map(minimum_cubes_required)
    |> Enum.map(calculate_power_level)
    |> Enum.sum()
  end
end
