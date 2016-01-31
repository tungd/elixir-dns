defmodule TestServer do
  @behaviour DNS.Server

  def start() do
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

    resource = %DNS.Resource{
      domain: query.domain,
      class: query.class,
      type: query.type,
      ttl: 0,
      data: {127, 0, 0, 1}
    }

    %{record | anlist: [resource]}
  end
end
