defmodule DigitalOcean.Mixfile do
  use Mix.Project

  def project do
    [app: :digital_ocean,
     version: "0.0.1",
     elixir: "~> 1.0",
     aliases: aliases,
     deps: deps]
  end

  def application do
    [applications: [:logger, :digoc]]
  end

  defp aliases do               # FIX: This doesn't actually work (but
                                # remains useful enough as a reminder
                                # on how to run the integration tests).
    [exttest: "test --include external"]
  end
  
  defp deps do
    [
        {:digoc, "~> 0.3.0"}
    ]
  end
end
