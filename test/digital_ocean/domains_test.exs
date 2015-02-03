defmodule DigitalOcean.DomainsTest do
  use ExUnit.Case

  setup do
    {data, _} = Code.eval_file("test/sample-data/domains", System.cwd)
    {:ok, fixtures: data}
  end

  test "domain struct created from fixture", %{ fixtures: d } do
    data = hd(d.domains)
    s = struct(DigitalOcean.Domains.Domain, data)
    assert s[:name] == "example.com"
    assert s.ttl == 1800
  end

  test "domains struct created form fixture", %{ fixtures: d } do
    s = struct(DigitalOcean.Domains, d)
    assert length(s.domains) == s.meta[:total]
    assert s.links == %{}
  end

  test "struct and embedded structs created", %{ fixtures: d } do
    {:ok, s} = DigitalOcean.Domains.as_struct(d)
    assert length(s.domains) == s.meta[:total]
    domain = hd(s.domains)
    assert domain.__struct__ == DigitalOcean.Domains.Domain
    assert domain.name == "example.com"
  end

  test "domains as enumeration", %{ fixtures: d } do
    {:ok, s} = DigitalOcean.Domains.as_struct(d)
    assert Enum.count(s) == s.meta[:total]
    assert Enum.member?(s, "example.com")
    refute Enum.member?(s, "notexample.com")
  end

  test "domains as iteration", %{ fixtures: d } do
    {:ok, s} = DigitalOcean.Domains.as_struct(d)
    res = for _ <- s, do: :ok
    assert res == List.duplicate(:ok, Enum.count(s))
  end

  @tag :external
  test "retrieve list of domains" do
    s = DigitalOcean.domains!
    {:ok, ^s} = DigitalOcean.domains
    IO.puts "s is #{ inspect s }"
  end

  
end
