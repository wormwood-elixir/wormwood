defmodule Wormwood.MixProject do
  use Mix.Project

  def project do
    [
      app: :wormwood,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:absinthe, "~> 1.4"},
      {:ex_doc, "~> 0.21.2", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    Wormwood is a tiny library to aid in testing GraphQL queries against an Absinthe schema.
    It allows you to test your query documents inside ExUnit test modules, and requires no HTTP requests to occur during testing.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Aaron Shea", "Tinfoil Security Inc."],
      licenses: ["MIT"],
      organization: "tinfoil",
      source_url: "https://github.com/tinfoil/wormwood",
      links: %{"GitHub" => "https://github.com/tinfoil/wormwood", "Tinfoil Website" => "https://tinfoilsecurity.com"}
    ]
  end
end
