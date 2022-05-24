defmodule DNS.Mixfile do
  use Mix.Project

  @source_url "https://github.com/tungd/elixir-dns"
  @version "2.3.0"

  def project do
    [
      app: :dns,
      version: @version,
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: [:dev], runtime: false},
      {:credo, "~> 0.9.0-rc1", only: [:dev, :test], runtime: false}
    ]
  end

  defp package do
    [
      description: "DNS library for Elixir using `inet_dns` module.",
      maintainers: ["Tung Dao", "João Veiga"],
      licenses: ["BSD-3-Clause"],
      links: %{
        "GitHub" => @source_url
      }
    ]
  end

  defp docs do
    [
      extras: [
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatters: ["html"]
    ]
  end
end
