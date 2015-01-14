defmodule DigitalOcean.Regions do

  @derive [Access]
  require DigitalOcean.Macros, as: Macros

  defmodule Region do
    @derive [Access]
    defstruct(slug:      nil,
              name:      nil,
              sizes:     nil,
              available: nil,
              features:  [])
  end

  defstruct(regions: [], links: %{}, meta: %{})
  Macros.define_as_struct(:regions, DigitalOcean.Regions.Region)
  Macros.implement_enumerable(:regions, DigitalOcean.Regions)
  
end

