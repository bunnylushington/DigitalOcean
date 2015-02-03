defmodule DigitalOcean.DomainRecordsTest do
  use ExUnit.Case

  setup do
    {data, _} = Code.eval_file("test/sample-data/records", System.cwd)
    {:ok, fixtures: data}
  end

  test "records struct created from fixture", %{fixtures: d} do
    data = hd(d.domain_records)
    s = struct(DigitalOcean.DomainRecords.Record, data)
    assert s[:data] == "ns1.digitalocean.com"
    assert s.type == "NS"
  end

  test "domain_records struct created from fixture", %{fixtures: d} do
    s = struct(DigitalOcean.DomainRecords, d)
    assert length(s.domain_records) == s.meta[:total]
    assert s.links == %{}
  end

  test "struct and embedded structs created", %{fixtures: d} do
    {:ok, s} = DigitalOcean.DomainRecords.as_struct(d)
    assert length(s.domain_records) == s.meta[:total]
    record = hd(s.domain_records)
    assert record.__struct__ == DigitalOcean.DomainRecords.Record
    assert record.data == "ns1.digitalocean.com"
  end

  test "records as enumeration", %{fixtures: d} do
    {:ok, s} = DigitalOcean.DomainRecords.as_struct(d)
    assert Enum.count(s) == s.meta[:total]
    assert Enum.member?(s, 3833164)
    assert Enum.member?(s, "test.example.com")
    refute Enum.member?(s, "quux.example.com")
  end

  test "records as iteration", %{fixtures: d} do
    {:ok, s} = DigitalOcean.DomainRecords.as_struct(d)
    res = for _ <- s, do: :ok
    assert res == List.duplicate(:ok, Enum.count(s))
  end

  @tag :external
  test "retrieve list of records, single record" do
    s = DigitalOcean.domain_records!("bapi.us")
    assert {:ok, ^s} = DigitalOcean.domain_records("bapi.us")
    record = Enum.fetch!(s, 0)
    assert record[:type] == "NS"
    assert ^record = DigitalOcean.domain_record!("bapi.us", record[:id])
  end

  @tag :external
  test "create, update, and delete single record" do
    rec = %DigitalOcean.DomainRecords.Record{type: "A",
                                             name: "quux.bapi.us",
                                             data: "192.168.1.1"}
    res = DigitalOcean.DomainRecords.create!("bapi.us", rec)
    id = res.id
    assert res.type == "A"
    assert res.name == "quux.bapi.us"
    assert res.data == "192.168.1.1"

    res = DigitalOcean.DomainRecords.update!("bapi.us", id, "quuxor.bapi.us")
    assert res.id == id
    assert res.name == "quuxor.bapi.us"

    lookup = DigitalOcean.domain_record!("bapi.us", id)
    assert res == lookup

    assert :ok == DigitalOcean.DomainRecords.destroy!("bapi.us", lookup)
    
  end
  
end
