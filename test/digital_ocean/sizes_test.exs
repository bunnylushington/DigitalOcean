defmodule DigitalOcean.SizesTest do
  use ExUnit.Case

  setup do
    {size_data, _} = Code.eval_file("test/sample-data/sizes", System.cwd)
    {:ok, fixtures: size_data}
  end
  
  test "size struct exists" do
    s = %DigitalOcean.Sizes.Size{}
    assert s.disk == nil
  end

  test "size struct created from fixture", %{fixtures: sizes} do
    data = hd(sizes.sizes)
    s = struct(DigitalOcean.Sizes.Size, data)
    assert s.disk == 20
    assert s.memory == 512
    assert s.price_hourly == 0.00744
    assert s.price_monthly == 5.0
    assert length(s.regions) == 9
    assert s.slug == "512mb"
    assert s.transfer == 1.0
    assert s[:vcpus] == 1
  end

  test "sizes struct created from fixture", %{fixtures: sizes} do
    s = struct(DigitalOcean.Sizes, sizes)
    assert length(s.sizes) == s.meta[:total]
    assert s.links == %{}
  end

  test "strut and embedded structs created", %{fixtures: sizes} do
    s = DigitalOcean.Sizes.as_struct(sizes)
    assert length(s.sizes) == s.meta[:total]
    size = hd(s.sizes)
    assert size.__struct__ == DigitalOcean.Sizes.Size
    assert size.slug == "512mb"
  end

  test "sizes as enumeration", %{fixtures: sizes} do
    s = DigitalOcean.Sizes.as_struct(sizes)
    assert Enum.count(s) == s.meta[:total]
    assert Enum.member?(s, "512mb")
    refute Enum.member?(s, "xyzzy")
    assert length(Enum.filter(s, fn(x) -> x.disk < 100 end)) == 5
  end

  test "sizes as an iteration", %{fixtures: sizes} do
    s = DigitalOcean.Sizes.as_struct(sizes)
    res = for _ <- s, do: :ok
    assert res == List.duplicate(:ok, Enum.count(s))
  end

  @tag :external
  test "retrieve and process sizes" do
    s = DigitalOcean.sizes
    res = for _ <- s, do: :ok
    assert res == List.duplicate(:ok, Enum.count(s))
  end
  
end
