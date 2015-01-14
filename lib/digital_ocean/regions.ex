defmodule DigitalOcean.Regions do

  @derive [Access]

  defmodule Region do
    @derive [Access]
    defstruct(slug:      nil,
              name:      nil,
              sizes:     nil,
              available: nil,
              features:  [])
  end

  defstruct(regions: [], links: %{}, meta: %{})

  def as_struct(data) do
    s = struct(__MODULE__, data)
    list = Enum.map(s.regions,
      fn(x) -> struct(DigitalOcean.Regions.Region, x) end)
    %{ s | regions: list }
  end

end

# ------------------------- Protocol Implementations.
