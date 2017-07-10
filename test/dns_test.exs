defmodule DNSTest do
  use ExUnit.Case
  doctest DNS

  describe "resolve" do
    test "works with default DNS servers" do
      {:ok, results} = DNS.resolve("www.google.com")

      assert is_list(results)
      assert length(results) > 0
    end

    test "works with custom DNS servers" do
      {:ok, results} = DNS.resolve("www.google.com", {"8.8.4.4", 53})

      assert is_list(results)
      assert length(results) > 0
    end

    test "works as expected with not found domain" do
      assert {:error, :not_found} = DNS.resolve('uifqourefhoqeirhfqeurfhqehfqoerfiuqe.com')
    end
  end

  describe "query" do
    test "works as expected" do
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
end
