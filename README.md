# DNS

[![Build Status](https://github.com/tungd/elixir-dns/actions/workflows/elixir.yml/badge.svg?branch=main)](https://github.com/tungd/elixir-dns/actions)
[![Module Version](https://img.shields.io/hexpm/v/dns.svg)](https://hex.pm/packages/dns)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/dns/)
[![Total Download](https://img.shields.io/hexpm/dt/dns.svg)](https://hex.pm/packages/dns)
[![License](https://img.shields.io/hexpm/l/dns.svg)](https://github.com/tungd/elixir-dns/blob/master/LICENSE)
[![Last Updated](https://img.shields.io/github/last-commit/tungd/elixir-dns.svg)](https://github.com/tungd/elixir-dns/commits/master)

DNS library for Elixir.

Currently, the package provides:

- Elixir structs to interface with `:inet_dns` module
- `DNS.Server` behavior
- DNS client

Note: the `:inet_dns` module is considered internal to Erlang and subject to
change. If this happened this library will be updated to accommodate for that,
but for now `:inet_dns` is simple and worked for me.

## Installation

Make sure you have the Erlang/OTP source files installed, otherwise the
compilation will fail with an `{:error, :enoent}` message. On Ubuntu, this can
be done using `apt-get install erlang-src`.

Add `:dns` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:dns, "~> 2.4.0"}
  ]
end
```

## Usage

### DNS client

```elixir
iex> DNS.resolve("google.com")
{:ok, [{216, 58, 221, 110}]}

iex> DNS.resolve("notfound.domain")
{:error, :not_found}

iex> DNS.query("google.com")
%DNS.Record{anlist: [%DNS.Resource{bm: [], class: :in, cnt: 0,
   data: {216, 58, 221, 110}, domain: 'google.com', func: false, tm: :undefined,
   ttl: 129, type: :a}], arlist: [],
 header: %DNS.Header{aa: false, id: 0, opcode: :query, pr: false, qr: true,
  ra: true, rcode: 0, rd: false, tc: false}, nslist: [],
 qdlist: [%DNS.Query{class: :in, domain: 'google.com', type: :a}]}

iex> DNS.resolve("google.com", :a, nameservers: [{"8.8.8.8", 53}])
...
```

### DNS server

```elixir
defmodule ServerExample do
  @moduledoc """
  Example implementing DNS.Server behaviour
  """
  @behaviour DNS.Server
  use DNS.Server

  def handle(record, _cl) do
    Logger.info(fn -> "#{inspect(record)}" end)
    query = hd(record.qdlist)

    result =
      case query.type do
        :a -> {127, 0, 0, 1}
        :cname -> 'your.domain.com'
        :txt -> ['your txt value']
        _ -> nil
      end

    resource = %DNS.Resource{
      domain: query.domain,
      class: query.class,
      type: query.type,
      ttl: 0,
      data: result
    }

    %{record | anlist: [resource], header: %{record.header | qr: true}}
  end
end
```

To run the example server in `iex`:

```elixir
iex> c "example/test_server.ex"
[ServerExample]
iex> {:ok, server_pid} = ServerExample.start_link 8000
Server listening at 8000
{:ok, #PID<0.180.0>}
iex> Process.exit(server_pid, :normal)
```

## Copyright and License

Copyright (c) 2016-2022 Tung Dao and contributors.

This library is released under the BSD 3-Clause "New" or "Revised" License. See
the [LICENSE.md](./LICENSE.md) file for further details.
