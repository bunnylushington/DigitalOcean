defmodule DigitalOcean.NeighborsTest do
  use ExUnit.Case

  setup do
    {data, _} = Code.eval_file("test/sample-data/neighbors", System.cwd)
    {:ok, fixtures: data}
  end

  test "created struct from fixtures", %{fixtures: d} do
    {:ok, s} = DigitalOcean.Neighbors.as_struct(d)
    assert s.__struct__ == DigitalOcean.Neighbors
    assert is_list(s.neighbors)
    neighborhood = hd(s.neighbors)
    assert is_list(neighborhood)
    first_neighbor = Enum.at(neighborhood, 0)
    assert first_neighbor.__struct__ == DigitalOcean.Droplets.Droplet
  end


  @tag :external
  test "request neighbors" do
    {:ok, s} = DigitalOcean.droplet_neighbors
    ^s = DigitalOcean.droplet_neighbors!
    IO.puts inspect s
  end
    
  
end
