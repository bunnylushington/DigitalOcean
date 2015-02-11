defmodule DigitalOcean.DropletsTest do
  use ExUnit.Case

  setup do
    {data, _} = Code.eval_file("test/sample-data/droplets", System.cwd)
    {:ok, fixtures: data}
  end

  test "droplet structs created", %{fixtures: d} do
    {:ok, s} = DigitalOcean.Droplets.as_struct(d)
    assert length(s.droplets) == s.meta.total
    assert Enum.count(s) == s.meta.total
    first = hd(s.droplets)
    assert first.networks.__struct__ == DigitalOcean.Networks
    assert first.kernel.__struct__   == DigitalOcean.Kernels.Kernel
    assert first.region.__struct__   == DigitalOcean.Regions.Region
    assert first.image.__struct__    == DigitalOcean.Images.Image
  end

  test "droplets are enums", %{fixtures: d} do
    {:ok, s} = DigitalOcean.Droplets.as_struct(d)
    assert Enum.count(s) == s.meta.total
    assert Enum.member?(s, "do")
    assert Enum.member?(s, 112233)
  end

  test "droplets as interable", %{fixtures: d} do
    {:ok, s} = DigitalOcean.Droplets.as_struct(d)
    res = for _ <- s, do: :ok
    assert res == List.duplicate(:ok, Enum.count(s))
  end

  @tag :external

  # -- NB: this sometimes fails!  The failure happens because the
  # -- region object that's returned isn't consistent request to
  # -- request.  A ticket's been opened with DO.
  
  test "list all droplets, specific droplet" do
    s = DigitalOcean.droplets!
    d = Enum.at(s, 0)
    droplet = DigitalOcean.droplet!(d.id)
    assert droplet.id == d.id
    # {:ok, ^s} = DigitalOcean.droplets
    # d = Enum.at(s, 0)
    # droplet = DigitalOcean.droplet!(d.id)
    # assert d == droplet
  end

  @tag :external
  test "list available kernels" do
    s = DigitalOcean.droplets!
    d = Enum.at(s, 0)
    kernels = DigitalOcean.kernels!(d.id)
    assert kernels.__struct__ == DigitalOcean.Kernels
    first = Enum.at(kernels, 0)
    assert first.__struct__ == DigitalOcean.Kernels.Kernel
  end

  @tag :external
  test "list available snapshots, backups, actions" do
    s = DigitalOcean.droplets!
    d = Enum.at(s, 0)
    snapshots = DigitalOcean.snapshots!(d.id)
    assert snapshots.__struct__ == DigitalOcean.Images
    backups = DigitalOcean.backups!(d.id)
    assert backups.__struct__ == DigitalOcean.Images
    actions = DigitalOcean.actions!({:droplet, d.id})
    assert actions.__struct__ == DigitalOcean.Actions
  end

end
