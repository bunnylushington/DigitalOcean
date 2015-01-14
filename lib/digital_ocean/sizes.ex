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
  end

  defstruct(sizes: [], links: %{}, meta: %{})
  Macros.define_as_struct(:sizes, DigitalOcean.Sizes.Size)
  Macros.implement_enumerable(:sizes, DigitalOcean.Sizes)
    
end

