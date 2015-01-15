defmodule DigitalOcean.Sizes do

  @derive [Access]
  require DigitalOcean.Macros, as: Macros

  defmodule Size do
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

  defstruct(sizes: [], links: %{}, meta: %{})
  @type t :: %__MODULE__{sizes: [DigitalOcean.Sizes.Size.t],
                         links: DigitalOcean.links,
                         meta: DigitalOcean.meta}
  
  Macros.define_as_struct(:sizes, DigitalOcean.Sizes.Size)
  Macros.implement_enumerable(:sizes, DigitalOcean.Sizes)
    
end

