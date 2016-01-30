defmodule DNS.Query do
  @moduledoc """
  TODO: docs
  """

  record = Record.extract(:dns_query, from_lib: "kernel/src/inet_dns.hrl")
  keys   = :lists.map(&elem(&1, 0), record)
  vals   = :lists.map(&{&1, [], nil}, keys)
  pairs  = :lists.zip(keys, vals)

  defstruct record
  @type t :: %__MODULE__{}

  @doc """
  Converts a `DNS.Query` struct to a `:dns_query` record.
  """
  def to_record(%DNS.Query{unquote_splicing(pairs)}) do
    {:dns_query, unquote_splicing(vals)}
  end

  @doc """
  Converts a `:dns_query` record into a `DNS.Query`.
  """
  def from_record(file_info)
  def from_record({:dns_query, unquote_splicing(vals)}) do
    %DNS.Query{unquote_splicing(pairs)}
  end
end
