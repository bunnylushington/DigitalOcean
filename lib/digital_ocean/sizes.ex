defmodule DigitalOcean.Sizes do

  @derive [Access]
  require DigitalOcean.Macros, as: Macros

  defstruct(sizes: [], links: %{}, meta: %{})
  @type t :: %__MODULE__{sizes: [DigitalOcean.Sizes.Size.t],
                         links: DigitalOcean.links,
                         meta: DigitalOcean.meta}
  
  Macros.define_as_struct(:sizes, DigitalOcean.Sizes.Size)
  Macros.implement_enumerable(:sizes, DigitalOcean.Sizes)
  
  defmodule Size do
    @moduledoc """
    Single Digital Ocean Size Struct

    Its fields are:

      * `slug` [string] - unique human readable identifier

      * `transfer` [number] - amount of transfer bandwidth (TB)

      * `price_monthly` [float] - monthly cost of droplet (USD)

      * `price_hourly` [float] - hourly cost of droplet (USD)

      * `memory` [integer] - amount of RAM (MB)

      * `vcpus` [integer] - number of virtual CPUs

      * `disk` [integer] - disk space set aside (GB)

      * `regions` [array] - region slugs where this size is available

    See [the Digital Ocean Sizes
    documentation](https://developers.digitalocean.com/#sizes) for
    full details.
    """
    @derive [Access]
    defstruct(disk:          nil,
              memory:        nil,
              price_hourly:  nil,
              price_monthly: nil,
              regions:       [],
              slug:          nil,
              transfer:      nil,
              vcpus:         nil)

    @type t :: %__MODULE__{slug: DigitalOcean.slug,
                           transfer: number,
                           price_monthly: float,
                           price_hourly: float,
                           memory: integer,
                           vcpus: integer,
                           disk: integer,
                           regions: [DigitalOcean.slug]}
  end
end

