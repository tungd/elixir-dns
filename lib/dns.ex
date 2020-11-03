defmodule DNS do
  import Socket.Datagram, only: [send!: 3, recv!: 2]

  @doc """
  Resolves the answer for a DNS query

  Example:

      iex> DNS.resolve("tungdao.com")                      # {:ok, [{1, 1, 1, 1}]}
      iex> DNS.resolve("tungdao.com", :txt)                # {:ok, [['v=spf1 a mx ~all']]}
      iex> DNS.resolve("tungdao.com", :a, {"8.8.8.8", 53}) # {:ok, [{1, 1, 1, 1}]}
  """
  @spec resolve(charlist, atom(), {String.t(), :inet.port()}) :: {atom, :inet.ip()} | {atom, atom}
  def resolve(domain, type \\ :a, dns_server \\ {"8.8.8.8", 53}) do
    case query(domain, type, dns_server).anlist do
      answers when is_list(answers) and length(answers) > 0 ->
        data =
          answers
          |> Enum.map(& &1.data)
          |> Enum.reject(&is_nil/1)

        {:ok, data}

      _ ->
        {:error, :not_found}
    end
  end

  @doc """
  Queries the DNS server and returns the result

  Examples:

      iex> DNS.query("tungdao.com")                              # <= Queries for A records
      iex> DNS.query("tungdao.com", :mx)                         # <= Queries for the MX records
      iex> DNS.query("tungdao.com", :a, { "208.67.220.220", 53}) # <= Queries for A records, using OpenDNS
  """
  def query(domain, type \\ :a, dns_server \\ {"8.8.8.8", 53}) do
    record = %DNS.Record{
      header: %DNS.Header{rd: true},
      qdlist: [%DNS.Query{domain: to_charlist(domain), type: type, class: :in}]
    }

    client = Socket.UDP.open!(0)

    send!(client, DNS.Record.encode(record), dns_server)

    {data, _server} = recv!(client, [{:timeout, 5_000}])

    :gen_udp.close(client)
    DNS.Record.decode(data)
  end
end
