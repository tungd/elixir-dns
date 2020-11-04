defmodule DNS.Resource do
  @moduledoc """
  TODO: docs
  """

  require Record

  record = Record.extract(:dns_rr, from_lib: "kernel/src/inet_dns.hrl")
  keys = :lists.map(&elem(&1, 0), record)
  vals = :lists.map(&{&1, [], nil}, keys)
  pairs = :lists.zip(keys, vals)

  defstruct record
  @type t :: %__MODULE__{}

  @doc """
  Converts a `DNS.Resource` or `DNS.ResourceOpt` struct to a `:dns_rr` or `:dns_rr_opt` record.
  """
  def to_record(resource)

  def to_record(%DNS.Resource{unquote_splicing(pairs)}) do
    {:dns_rr, unquote_splicing(vals)}
  end

  def to_record(%DNS.ResourceOpt{} = rr_opt) do
    DNS.ResourceOpt.to_record(rr_opt)
  end

  @doc """
  Converts a `:dns_rr` or `:dns_rr_opt` record into a `DNS.Resource` or `DNS.ResourceOpt`.
  """
  def from_record(record)

  def from_record(record) when Record.is_record(record, :dns_rr) do
    _from_record(record)
  end

  def from_record(record) when Record.is_record(record, :dns_rr_opt) do
    DNS.ResourceOpt.from_record(record)
  end

  def from_record(_), do: nil

  defp _from_record({:dns_rr, unquote_splicing(vals)}) do
    %DNS.Resource{unquote_splicing(pairs)}
  end
end
