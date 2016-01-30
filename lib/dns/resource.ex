defmodule DNS.Resource do
  @moduledoc """
  TODO: docs
  """

  record = Record.extract(:dns_rr, from_lib: "kernel/src/inet_dns.hrl")
  keys   = :lists.map(&elem(&1, 0), record)
  vals   = :lists.map(&{&1, [], nil}, keys)
  pairs  = :lists.zip(keys, vals)

  defstruct keys
  @type t :: %__MODULE__{}

  @doc """
  Converts a `DNS.ResourceRecord` struct to a `:dns_rr` record.
  """
  def to_record(%DNS.Resource{unquote_splicing(pairs)}) do
    {:dns_rr, unquote_splicing(vals)}
  end

  @doc """
  Converts a `:dns_rr` record into a `DNS.ResourceRecord`.
  """
  def from_record(dns_rr)
  def from_record({:dns_rr, unquote_splicing(vals)}) do
    %DNS.Resource{unquote_splicing(pairs)}
  end
end
