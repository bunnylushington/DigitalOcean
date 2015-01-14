defmodule DigitalOcean.RegionsTest do
  use ExUnit.Case

  setup do
    {region_data, _} = Code.eval_file("test/sample-data/regions", System.cwd)
    {:ok, fixtures: region_data}
  end

  test "region struct exists" do
    s = %DigitalOcean.Regions.Region{}
    assert s.name == nil
  end

  test "region struct created from fixture", %{fixtures: regions} do
    data = hd(regions.regions)
    s = struct(DigitalOcean.Regions.Region, data)
    assert s.name == "New York 1"
  end

  test "regions struct created from fixture", %{fixtures: regions} do
    s = struct(DigitalOcean.Regions, regions)
    assert length(s.regions) == s.meta[:total]
    assert s.links == %{}
  end

  test "struct and embedded structs created", %{fixtures: regions} do
    s = DigitalOcean.Regions.as_struct(regions)
    assert length(s.regions) == s.meta[:total]
    region = hd(s.regions)
    assert region.__struct__ == DigitalOcean.Regions.Region
    assert region.slug == "nyc1"
  end
  
end
