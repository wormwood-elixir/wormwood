defmodule Wormwood.MixProject do
  use Mix.Project

  def project do
    [
      app: :wormwood,
      version: "1.0.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
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
      {:excoveralls, "~> 0.10", only: :test},
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
      links: %{"GitHub" => "https://github.com/tinfoil/wormwood", "Tinfoil Website" => "https://www.tinfoilsecurity.com/go/opensource"}
    ]
  end
end
