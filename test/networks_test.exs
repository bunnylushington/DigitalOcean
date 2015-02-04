defmodule DigitalOcean.NetworksTest do
  use ExUnit.Case

  setup do
    {data, _} = Code.eval_file("test/sample-data/droplets", System.cwd)
    {:ok, fixtures: data}
  end

  test "test network struct completion", %{fixtures: d} do
    networks = for droplet <- d.droplets do
      DigitalOcean.Networks.to_struct(droplet.networks)
    end
    assert length(networks) == 2

    detail = hd(networks)[:v4] |> hd
    assert detail.__struct__ == DigitalOcean.Networks.Network
    assert hd(networks)[:v6] == []
  end
   
  
end
