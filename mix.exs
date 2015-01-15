defmodule DigitalOcean.Mixfile do
  use Mix.Project

  def project do
    [app: :digital_ocean,
     version: "0.0.1",
     elixir: "~> 1.0",
     aliases: aliases,
     docs: docs,
     pacakge: package,
     deps: deps]
  end

  defp docs do
    [
        source_url: "https://github.com/kevinmontuori/DigitalOcean",
    ]
  end

  defp package do
    [
        files: ["lib", "mix.exs", "README*", "LICENSE*", "test"],
        contributors: ["Kevin Montuori"],
        licenses: ["MIT"],
        links: %{ "GitHub" => "https://github.com/kevinmotnuori/DigitalOcean",
                  "Documentation" => "http://hexdocs.pm/digital_ocean" }
    ]
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
        {:digoc,   "~> 0.3.0"},
        {:earmark, "~> 0.1", only: :dev},
        {:ex_doc,  "~> 0.6", only: :dev}
    ]
  end
end
