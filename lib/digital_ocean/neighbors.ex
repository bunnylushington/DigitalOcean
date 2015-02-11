defmodule DigitalOcean.Neighbors do

  @moduledoc """ 
  This feels like a hack both here and on the D.O. server side.
  Rather than return the same structure that almost all the rest of
  the API returns (with meta and links keys) this just returns a list
  of lists representing neighbors.  I've opted to provide some
  functionality here but not all of what one might expect (e.g.,
  Enumerable isn't implemented).  I'll revisit this once the feature
  matures a little.
  """
  
  @derive [Access]
  require DigitalOcean.Macros, as: Macros

  defstruct(neighbors: [])
  @type t :: %__MODULE__{neighbors: [ [DigitalOcean.Droplets.Droplet.t] ]}

  Macros.define_as_struct(:neighbors, DigitalOcean.Neighbors.Neighborhood)

  defmodule Neighborhood do
    def as_struct(data) do
      for d <- data, do: struct(DigitalOcean.Droplets.Droplet, d)
    end
  end

end
