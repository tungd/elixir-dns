defmodule DNS.Server do
  @moduledoc """
  TODO: docs
  """

  @callback handle(DNS.Record) :: DNS.Record

  def start(port) do
    IO.puts "Server listening at #{port}"

    # TODO: see options
    server = Socket.UDP.open!(port)
    {data, client} = server |> Socket.Datagram.recv!

    record = DNS.Record.decode(data)

    # if !record.header.qr do
      IO.puts inspect(client)
      IO.puts inspect(record)

      [query | _] = record.qdlist
      resource = %DNS.Resource{
        domain: query.domain,
        class: query.class,
        type: query.type,
        ttl: 0,
        data: {127, 0, 0, 1}
      }
      response = %{record | anlist: [resource]}

      server |> Socket.Datagram.send!(DNS.Record.encode(response), client)
    # end

    # server |> Socket.Datagram.send!(data, client)
  end
end
