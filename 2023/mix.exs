defmodule Advent.MixProject do
  use Mix.Project

  def project do
    [
      app: :advent,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      test_paths: test_paths(Mix.env())
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp elixirc_paths(_env) do
    ["days", "lib"]
  end

  defp test_paths(_env) do
    ["days", "lib"]
  end

  defp deps do
    [{:benchee, "~> 1.2"}]
  end
end
