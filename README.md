# DNS
![https://hex.pm/packages/dns](https://img.shields.io/hexpm/v/dns.svg)

DNS library for Elixir. Currently, the package provides:

- Elixir structs to interface with `inet_dns` module.
- DNS.Server behavior
- DNS client

Note: the `inet_dns` module is considered internal to Erlang and subject to
change. If this happened this library will be updated to accommodate for that,
but for now `inet_dns` is simple and worked for me.

## Installation

The package is available in [Hex](https://hex.pm) and can be installed as:

  1. Add dns to your list of dependencies in `mix.exs`:

        ```elixir
        def deps do
          [{:dns, "~> 0.0.3"}]
        end
        ```

  2. Ensure dns is started before your application:

        ```elixir
        def application do
          [applications: [:dns]]
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

iex> DNS.resolve("google.com", {"8.8.8.8", 53})
...
```

### DNS server

```elixir
defmodule TestServer do
  use Application

  @behaviour DNS.Server

  def start(_args, _opts) do
    import Supervisor.Spec, warn: false

    port = Application.get_env(:dns, :server)[:port]
    children = [
      worker(Task, [DNS.Server, :accept, [port, __MODULE__]])
    ]

    opts = [strategy: :one_for_one, name: DNS.Server.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def handle(record, {ip, _}) do
    query = hd(record.qdlist)

    result = case query.type do
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

    %{record | anlist: [resource]}
  end
end
```

For more information, see [API Reference](https://hexdocs.pm/dns/1.0.1/api-reference.html)

## License

BSD-3-Clauses
