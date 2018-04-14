defmodule DNS.Record do
  @moduledoc """
  TODO: docs
  """

  record = Record.extract(:dns_rec, from_lib: "kernel/src/inet_dns.hrl")
  keys = :lists.map(&elem(&1, 0), record)
  vals = :lists.map(&{&1, [], nil}, keys)
  pairs = :lists.zip(keys, vals)

  defstruct record
  @type t :: %__MODULE__{}

  @doc """
  Converts a `DNS.Record` struct to a `:dns_rec` record.
  """
  def to_record(struct) do
    header = DNS.Header.to_record(struct.header)
    queries = Enum.map(struct.qdlist, &DNS.Query.to_record/1)
    answers = Enum.map(struct.anlist, &DNS.Resource.to_record/1)

    _to_record(%{struct | header: header, qdlist: queries, anlist: answers})
  end

  defp _to_record(%DNS.Record{unquote_splicing(pairs)}) do
    {:dns_rec, unquote_splicing(vals)}
  end

  @doc """
  Converts a `:dns_rec` record into a `DNS.Record`.
  """
  def from_record(dns_rec)

  def from_record({:dns_rec, unquote_splicing(vals)}) do
    struct = %DNS.Record{unquote_splicing(pairs)}

    header = DNS.Header.from_record(struct.header)
    queries = Enum.map(struct.qdlist, &DNS.Query.from_record(&1))
    answers = Enum.map(struct.anlist, &DNS.Resource.from_record(&1))

    %{struct | header: header, qdlist: queries, anlist: answers}
  end

  # TODO: docs
  def decode(data) do
    {:ok, record} = :inet_dns.decode(data)
    from_record(record)
  end

  # TODO: docs
  def encode(struct) do
    :inet_dns.encode(to_record(struct))
  end
end
