defmodule DNS do

  @type nameserver :: {String.t(), port :: 1..65535}
  @type res_option ::
  :inet_res.res_option()
  | {:alt_nameservers, [nameserver()]}
  | {:nameservers, [nameserver()]}
  # :inet_res.rr_type is not exported
  @type rr_type :: :a | :aaaa | :caa | :cname | :gid | :hinfo | :ns | :mb | :md | :mg
  | :mf | :minfo | :mx | :naptr | :null | :ptr | :soa | :spf | :srv
  | :txt | :uid | :uinfo | :unspec | :uri | :wks

  @doc """
  Resolves the answer for a DNS query.

  ## Examples

      iex> DNS.resolve("tungdao.com")
      {:ok, [{1, 1, 1, 1}]}

      iex> DNS.resolve("tungdao.com", :txt)
      {:ok, [['v=spf1 a mx ~all']]}

      iex> DNS.resolve("tungdao.com", :a, nameservers: [{"8.8.4.4", 53}])
      {:ok, [{1, 1, 1, 1}]}

      iex> DNS.resolve("tungdao.com", :a, usevc: true)
      {:ok, [{1, 1, 1, 1}]}

  """
  @spec resolve(String.t(), rr_type(), [res_option()], timeout()) :: {:ok, list()} | {:error, :inet_res.res_error()}
  def resolve(domain, type \\ :a, opts \\ [], timeout \\ :infinity) do
    case query(domain, type, opts, timeout) do
      {:ok, %DNS.Record{anlist: anlist}} when is_list(anlist) and length(anlist) > 0 ->
        data =
          anlist
          |> Enum.map(& &1.data)
          |> Enum.reject(&is_nil/1)

        {:ok, data}

      {:ok, %DNS.Record{anlist: anlist}} when is_list(anlist) and length(anlist) == 0 ->
        {:error, :not_found}

      error ->
        error
    end
  end

  @doc """
  Queries the DNS server and returns the result.

  ## Examples

  Queries for A records:

      iex> DNS.query("tungdao.com")

  Queries for the MX records:

      iex> DNS.query("tungdao.com", :mx)

  Queries for A records, using OpenDNS:

      iex> DNS.query("tungdao.com", :a, nameservers: [{"8.8.4.4", 53}])


  Queries for A records, using OpenDNS, with TCP:

      iex> DNS.query("tungdao.com", :a, nameservers: [{"8.8.4.4", 53}], usevc: true)

  """
  @spec query(String.t(), rr_type(), [res_option()], timeout()) :: {:ok, DNS.Record.t()} | {:error, :inet_res.res_error()}
  def query(name, type \\ :a, opts \\ [], timeout \\ :infinity) do
    case :inet_res.resolve(to_charlist(name), :in, type, transform_opts(opts), timeout) do
      {:ok, response} ->
        {:ok, DNS.Record.from_record(response)}

      {:error, error} ->
        {:error, error}
    end
  end

  defp transform_opts(opts) do
    Enum.map(opts, fn {key, value} -> {key, transform_opt(key, value)} end)
  end

  defp transform_opt(key, nameservers) when key in [:alt_nameservers, :nameservers] and is_list(nameservers) do
    Enum.map(nameservers, fn {nameserver, port} ->
      case nameserver do
        n when is_tuple(n) -> {n, port}
        n when is_binary(n) ->
          {:ok, address} = :inet.parse_address(to_charlist(n))
          {address, port}
      end
    end)
  end

  defp transform_opt(_key, value) do
    value
  end
end
