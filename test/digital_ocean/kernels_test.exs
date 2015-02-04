defmodule DigitalOcean.KernelsTest do
  use ExUnit.Case

  setup do
    {data, _} = Code.eval_file("test/sample-data/droplets", System.cwd)
    {:ok, fixtures: data}
  end
  
  test "test kernel struct creation", %{fixtures: d} do
    kernels = for droplet <- d.droplets do
      DigitalOcean.Kernels.Kernel.as_struct(droplet.kernel)
    end
    assert Enum.all?(kernels,
      fn(k) -> k.__struct__ == DigitalOcean.Kernels.Kernel end)
  end
  
end
