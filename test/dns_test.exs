defmodule DNSTest do
  use ExUnit.Case
  doctest DNS

  test '#resolve' do
    actual = DNS.resolve('tungdao.com', {'ns1.linode.com', 53})
    assert {172, 104, 54, 197} = actual
  end

  test '#query' do
    assert %DNS.Record{
      anlist: [],
      arlist: [],
      header: %DNS.Header{aa: false, id: 0, opcode: :query, pr: false,
                          qr: true, ra: true, rcode: 2, rd: false, tc: false},
      nslist: [],
      qdlist: [%DNS.Query{class: :in, domain: 'tungdao.com', type: :a}]
    } = DNS.query('tungdao.com')
  end
end
