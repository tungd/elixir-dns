defmodule DNSTest do
  use ExUnit.Case
  doctest DNS

  test "#resolve" do
    actual = DNS.resolve("tungdao.com", {"freedns1.registrar-servers.com", 53})
    assert {128, 199, 109, 154} = actual
  end

  test "#query" do
    %DNS.Record{
      anlist: [%DNS.Resource{domain: 'github.com'}],
      qdlist: [%DNS.Query{class: :in, domain: 'github.com', type: :a}]
    } = DNS.query("github.com")
  end
end
