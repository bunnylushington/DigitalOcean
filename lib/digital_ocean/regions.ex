defmodule DigitalOcean.Regions do

  @derive [Access]
  require DigitalOcean.Macros, as: Macros


  defstruct(regions: [], links: %{}, meta: %{})

  @type t :: %__MODULE__{regions: [DigitalOcean.Regions.Region.t],
                         links: DigitalOcean.links,
                         meta: DigitalOcean.meta}
  
  Macros.define_as_struct(:regions, DigitalOcean.Regions.Region)
  Macros.implement_enumerable(:regions, DigitalOcean.Regions)


  defmodule Region do
    @moduledoc """
    Single Digital Ocean Region Struct

    Its fields are:

      * `slug` [string] - human readable unique identifier
  
      * `name` [string] - display name of the region

      * `sizes` [array] - array of size slugs available in the region

      * `available` [boolean] - true if droplets can be created in the region

      * `features` [array] - array of features available in the region

    
    See [the Digital Ocean Regions
    documentation](https://developers.digitalocean.com/#regions) for
    full details.
    """
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
end

