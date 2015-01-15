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

    @type t :: %__MODULE__{slug: DigitalOcean.slug,
                           name: String.t,
                           sizes: [DigitalOcean.slug],
                           available: boolean,
                           features: [String.t]}
    
  end

  defstruct(regions: [], links: %{}, meta: %{})

  @type t :: %__MODULE__{regions: [DigitalOcean.Regions.Region.t],
                         links: DigitalOcean.links,
                         meta: DigitalOcean.meta}
  
  Macros.define_as_struct(:regions, DigitalOcean.Regions.Region)
  Macros.implement_enumerable(:regions, DigitalOcean.Regions)
  
end

