defmodule DNS.Server do
  @moduledoc """
  TODO: docs
  TODO: convert this to a `GenServer` and do proper cleanup
  """

  @callback handle(DNS.Record.t, {:inet.ip, :inet.port}) :: DNS.Record.t

  @doc """
  TODO: docs
  """
  @spec accept(:inet.port, DNS.Server) :: no_return
  def accept(port, handler) do
    socket = Socket.UDP.open!(port)
    IO.puts "Server listening at #{port}"

    accept_loop(socket, handler)
  end

  defp accept_loop(socket, handler) do
    {data, client} = Socket.Datagram.recv!(socket)

    record = DNS.Record.decode(data)
    response = handler.handle(record, client)
    Socket.Datagram.send!(socket, DNS.Record.encode(response), client)

    accept_loop(socket, handler)
  end
end
