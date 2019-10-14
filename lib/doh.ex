defmodule DOH do
  def resolve(domain, type \\ :a, dns_server \\ {"https://dns.google/dns-query", []}) do
    case query(domain, type, dns_server).anlist do
      answers when is_list(answers) and length(answers) > 0 ->
        data = answers
               |> Enum.map(& &1.data)
               |> Enum.reject(&is_nil/1)
        {:ok, data}

      _ ->
        {:error, :not_found}
    end
  end

  def query(domain, type \\ :a, dns_server \\ {"https://dns.google/dns-query", []}) do
    record = %DNS.Record{
      header: %DNS.Header{rd: true},
      qdlist: [%DNS.Query{domain: to_charlist(domain), type: type, class: :in}]
    }

    dns_request = DNS.Record.encode(record)

    {http_server, options} = dns_server
    case HTTPoison.post(http_server, dns_request, [{"Content-Type", "application/dns-message"}], options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response}} ->
        DNS.Record.decode(response)
      {:ok, %HTTPoison.Response{status_code: 301}} ->
          {:error, "moved"}
      {:error, %HTTPoison.Error{reason: reason}} ->
          {:error, reason}
    end  
  end
end
