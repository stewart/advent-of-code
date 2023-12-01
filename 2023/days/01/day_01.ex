defmodule Day01 do
  @moduledoc """
  Day 01: Trebuchet?!
  """

  import Advent

  datafile = Path.join(__DIR__, "data")

  @external_resource datafile
  @input datafile |> File.read!() |> String.split("\n", trim: true)

  def input, do: @input

  def part1 do
    calibration_value = fn line ->
      [first, last] =
        for line <- [line, String.reverse(line)],
            chars = String.graphemes(line),
            do: Enum.find(chars, &as_integer/1)

      as_integer(first <> last)
    end

    input()
    |> Enum.map(calibration_value)
    |> Enum.sum()
  end

  def part2 do
    calibration_value = fn line ->
      len = String.length(line)

      first =
        Enum.reduce_while(1..len, line, fn _, acc ->
          cond do
            n = starts_with_integer(acc) -> {:halt, "#{n}"}
            n = starts_with_named_num(acc) -> {:halt, "#{n}"}
            true -> {:cont, String.slice(acc, 1..-1)}
          end
        end)

      last =
        Enum.reduce_while(1..len, line, fn _, acc ->
          cond do
            n = ends_with_integer(acc) -> {:halt, "#{n}"}
            n = ends_with_named_num(acc) -> {:halt, "#{n}"}
            true -> {:cont, String.slice(acc, 0..-2)}
          end
        end)

      as_integer(first <> last)
    end

    input()
    |> Enum.map(calibration_value)
    |> Enum.sum()
  end

  defp as_integer("" <> str, fun \\ &String.first/1) do
    case str |> fun.() |> Integer.parse() do
      {n, _} -> n
      :error -> nil
    end
  end

  defp starts_with_integer("" <> str) do
    str |> String.first() |> as_integer()
  end

  defp ends_with_integer("" <> str) do
    str |> String.last() |> as_integer()
  end

  @named_nums ~w[one two three four five six seven eight nine]

  defp named_nums, do: Enum.with_index(@named_nums, 1)

  defp starts_with_named_num("" <> str) do
    Enum.find_value(named_nums(), fn {name, num} ->
      String.starts_with?(str, name) && num
    end)
  end

  defp ends_with_named_num("" <> str) do
    Enum.find_value(named_nums(), fn {name, num} ->
      String.ends_with?(str, name) && num
    end)
  end
end
