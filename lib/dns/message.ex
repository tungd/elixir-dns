defmodule DNS.Message do
  @moduledoc """
  TODO: docs
  """

  record = Record.extract(:dns_message, from_lib: "dns_erlang/include/dns_records.hrl")
  keys   = :lists.map(&elem(&1, 0), record)
  vals   = :lists.map(&{&1, [], nil}, keys)
  pairs  = :lists.zip(keys, vals)

  defstruct keys
  @type t :: %__MODULE__{}

  def to_record(%DNS.Record{unquote_splicing(pairs)}) do
    {:dns_rec, unquote_splicing(vals)}
  end

  @doc """
  Converts a `:dns_rec` record into a `DNS.Record`.
  """
  def from_record(dns_rec)
  def from_record({:dns_rec, unquote_splicing(vals)}) do
    %DNS.Record{unquote_splicing(pairs)}
  end
end
