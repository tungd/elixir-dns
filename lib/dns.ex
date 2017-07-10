defmodule DNS do
  import Socket.Datagram, only: [send!: 3, recv!: 1]

  @doc """
  TODO: docs
  TODO: handle errors
  """
  @spec resolve(char_list | char_list, { String.t, :inet.port }) :: :inet.ip
  def resolve(domain, dns_server \\ { "8.8.8.8", 53 }) do
    [ answer | _ ] = query(domain, dns_server).anlist
    answer.data
  end

  @doc """
  TODO: docs
  """
  @spec query(char_list | char_list, { String.t, :inet.port }) :: DNS.Record.t
  def query(domain, dns_server \\ { "8.8.8.8", 53 }) do
    record = %DNS.Record{
      header: %DNS.Header{rd: true},
      qdlist: [%DNS.Query{domain: to_char_list(domain), type: :a, class: :in}]
    }

    client = Socket.UDP.open!(0)

    send!(client, DNS.Record.encode(record), dns_server)

    { data, _server } = recv!(client)
    DNS.Record.decode(data)
  end
end
