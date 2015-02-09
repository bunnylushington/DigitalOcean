defmodule DigitalOcean.KernelsTest do
  use ExUnit.Case

  setup do
    {data, _} = Code.eval_file("test/sample-data/droplets", System.cwd)
    {kerns, _} = Code.eval_file("test/sample-data/kernels", System.cwd)
    {:ok, droplet: data, kernels: kerns}
  end
  
  test "test kernel struct creation from droplet data", %{droplet: d} do
    kernels = for droplet <- d.droplets do
      DigitalOcean.Kernels.Kernel.as_struct(droplet.kernel)
    end
    assert Enum.all?(kernels,
      fn(k) -> k.__struct__ == DigitalOcean.Kernels.Kernel end)
  end

  test "build kernel struct from kernel fixture data", %{kernels: d} do
    {:ok, s} = DigitalOcean.Kernels.as_struct(d)
    assert s.__struct__ == DigitalOcean.Kernels
    k = Enum.at(s, 0)
    assert k.__struct__ == DigitalOcean.Kernels.Kernel
  end

  
end
