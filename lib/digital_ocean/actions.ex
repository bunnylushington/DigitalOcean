defmodule DigitalOcean.Actions do

  @derive [Access]
  require DigitalOcean.Macros, as: Macros

  defmodule Action do
    @derive [Access]

    defstruct(id: nil,
              status: nil,
              type: nil,
              started_at: nil,
              completed_at: nil,
              resource_id: nil,
              resource_type: nil,
              region: nil)

    @type t :: %__MODULE__{id: integer,
                           status: String.t,
                           type: String.t,
                           started_at: DigitalOcean.isotime,
                           completed_at: DigitalOcean.isotime,
                           resource_id: integer,
                           resource_type: String.t,
                           region: DigitalOcean.slug}
                          
  end

  defstruct(actions: [], links: %{}, meta: %{})
  @type t :: %__MODULE__{actions: [DigitalOcean.Actions.Action],
                         links: DigitalOcean.links,
                         meta: DigitalOcean.meta}
  
  Macros.define_as_struct(:actions, DigitalOcean.Actions.Action)
  Macros.implement_enumerable(:actions, DigitalOcean.Actions)
  def get_next_page(url), do: as_struct(DigOc.page!(url))
  
end
