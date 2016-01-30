# DNS

DNS library for Elixir. Currently, the package provides:

- Elixir structs to interface with [`dns_erlang`][dns_erlang] module.
- DNS.Server behavior
- DNS.Client

Note: There's `inet_dns` module included in Erlang distribution. If you want to
use it (for example: reduce the code size), please use
`elixir_inet_dns`. However, please note that `inet_dns` is considered internal
to Erlang and subject to change.

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

[dns_erlang]: https://github.com/aetrion/dns_erlang/blob/master/include/dns_records.hrl
