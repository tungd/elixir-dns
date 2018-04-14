defmodule DNSTest do
  use ExUnit.Case

  describe "resolve" do
    test "defaults DNS servers" do
      {:ok, results} = DNS.resolve("www.google.com")

      assert is_list(results)
      assert length(results) > 0
    end

    test "can query custom DNS servers" do
      {:ok, results} = DNS.resolve("www.google.com", :a, {"8.8.4.4", 53})

      assert is_list(results)
      assert length(results) > 0
    end

    test "responds with error if domain not found" do
      assert {:error, :not_found} = DNS.resolve('uifqourefhoqeirhfqeurfhqehfqoerfiuqe.com')
    end
  end

  describe "query" do
    # test "builds a DNS Record" do
    #   assert %DNS.Record{
    #            anlist: [%DNS.Resource{}],
    #            arlist: [],
    #            header: %DNS.Header{},
    #            nslist: [],
    #            qdlist: [%DNS.Query{}]
    #          } = DNS.query('tungdao.com')
    # end

    # test "queries different record types" do
    #   assert %DNS.Record{
    #            anlist: [%DNS.Resource{}],
    #            arlist: [],
    #            header: %DNS.Header{},
    #            nslist: [],
    #            qdlist: [%DNS.Query{}]
    #          } = DNS.query('tungdao.com', :txt)
    # end
  end
end
