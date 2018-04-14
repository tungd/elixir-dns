defmodule DNS.Server do
  @moduledoc """
  TODO: docs
  TODO: convert this to a `GenServer` and do proper cleanup
  """

  @callback handle(DNS.Record.t(), {:inet.ip(), :inet.port()}) :: DNS.Record.t()

  defmacro __using__(_) do
    quote [] do
      use GenServer

      @doc """
      TODO: docs
      """
      def start_link(port) do
        GenServer.start_link(__MODULE__, [port])
      end

      def init([port]) do
        socket = Socket.UDP.open!(port, as: :binary, mode: :active)
        IO.puts("Server listening at #{port}")

        # accept_loop(socket, handler)
        {:ok, %{port: port, socket: socket}}
      end

      def handle_info({:udp, client, ip, wtv, data}, state) do
        record = DNS.Record.decode(data)
        response = handle(record, client)
        Socket.Datagram.send!(state.socket, DNS.Record.encode(response), {ip, wtv})
        {:noreply, state}
      end
    end
  end
end
