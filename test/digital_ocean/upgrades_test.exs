defmodule DigitalOcean.UpgradesTest do
  use ExUnit.Case

  setup do
    {upgrade_data, _} = Code.eval_file("test/sample-data/upgrades", System.cwd)
    {:ok, fixtures: upgrade_data}
  end

  test "can create list", %{fixtures: d} do
    list = DigitalOcean.Upgrades.as_list(d)
    assert Enum.all?(list, &(&1.__struct__ == DigitalOcean.Upgrades.Upgrade))
    assert hd(list).droplet_id == 123
  end
  
end
