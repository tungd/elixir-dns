# DNS

DNS library for Elixir. Currently, the package provides:

- Elixir structs to interface with `inet_dns` module.
- DNS.Server behavior
- DNS.Client

Note: the `inet_dns` module is considered internal to Erlang and subject to
change. If this happened this library will be updated to accommodate for that,
but for now `inet_dns` is simple and worked for me.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add dns to your list of dependencies in `mix.exs`:

        def deps do
          [{:dns, "~> 0.0.1"}]
        end

  2. Ensure dns is started before your application:

        def application do
          [applications: [:dns]]
        end
