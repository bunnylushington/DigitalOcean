defmodule DigitalOcean.ImagesTest do
  use ExUnit.Case

  setup do
    {data, _} = Code.eval_file("test/sample-data/images", System.cwd)
    {:ok, fixtures: data}
  end

  test "image struct created from fixture", %{fixtures: d} do
    data = hd(d.images)
    s = struct(DigitalOcean.Images.Image, data)
    assert s[:distribution] == "Ubuntu"
    assert s.min_disk_size == 20
  end

  test "images struct created from fixture", %{fixtures: d} do
    s = struct(DigitalOcean.Images, d)
    assert length(s.images) == s.meta[:total]
    assert s.links == %{}
  end

  test "struct and embedded struts created", %{fixtures: d} do
    {:ok, s} = DigitalOcean.Images.as_struct(d)
    assert length(s.images) == s.meta[:total]
    image = hd(s.images)
    assert image.__struct__ == DigitalOcean.Images.Image
    assert image.distribution == "Ubuntu"
  end

  test "images as enumeration", %{fixtures: d} do
    {:ok, s} = DigitalOcean.Images.as_struct(d)
    assert Enum.count(s) == s.meta[:total]
    assert Enum.member?(s, 6732690)
    assert Enum.member?(s, "LAMP on 14.04")
    refute Enum.member?(s, 112233)
  end

  test "images as iteration", %{fixtures: d} do
    {:ok, s} = DigitalOcean.Images.as_struct(d)
    res = for _ <- s, do: :ok
    assert res == List.duplicate(:ok, Enum.count(s))
  end
  
end
