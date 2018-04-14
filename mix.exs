defmodule DNS.Mixfile do
  use Mix.Project

  def project do
    [
      app: :dns,
      version: "2.1.0",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:socket, "~> 0.3.13"},
      {:ex_doc, ">= 0.0.0", only: [:dev]},
      {:earmark, ">= 0.0.0", only: [:dev]},
      {:credo, "~> 0.9.0-rc1", only: [:dev, :test], runtime: false}
    ]
  end

  defp description do
    """
    DNS library for Elixir using `inet_dns` module.

    Note: The `inet_dns` module is considered internal to Erlang and subject to
    change. If this happened this library will be updated.
    """
  end

  defp package do
    [
      maintainers: ["Tung Dao", "João Veiga"],
      licenses: ["BSD-3-Clauses"],
      links: %{
        "GitHub" => "https://github.com/tungd/elixir-dns",
        "API Reference" => "http://hexdocs.pm/dns/2.1.0/api-reference.html"
      }
    ]
  end
end
