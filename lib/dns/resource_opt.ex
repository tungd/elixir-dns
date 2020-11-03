defmodule DNS.ResourceOpt do
  @moduledoc """
  Elixir struct for RFC2671/6891's OPT RR records.
  The corresponding record in inet_dns is :dns_rr_opt
  """

  record = Record.extract(:dns_rr_opt, from_lib: "kernel/src/inet_dns.hrl")
  keys = :lists.map(&elem(&1, 0), record)
  vals = :lists.map(&{&1, [], nil}, keys)
  pairs = :lists.zip(keys, vals)

  defstruct record

  @type t :: %__MODULE__{}

  @doc """
  Converts a `DNS.ResourceOpt` struct to a `:dns_rr_opt` record.
  """
  def to_record(%DNS.ResourceOpt{unquote_splicing(pairs)}) do
    {:dns_rr_opt, unquote_splicing(vals)}
  end

  @doc """
  Converts a `:dns_rr_opt` record into a `DNS.ResourceOpt`.
  """
  def from_record(dns_rr_opt)

  def from_record({:dns_rr_opt, unquote_splicing(vals)}) do
    %DNS.ResourceOpt{unquote_splicing(pairs)}
  end

  def from_record(_), do: nil
end
