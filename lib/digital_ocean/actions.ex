defmodule DigitalOcean.Actions do

  @derive [Access]
  require DigitalOcean.Macros, as: Macros


  defstruct(actions: [], links: %{}, meta: %{})
  @type t :: %__MODULE__{actions: [DigitalOcean.Actions.Action],
                         links: DigitalOcean.links,
                         meta: DigitalOcean.meta}
  
  Macros.define_as_struct(:actions, DigitalOcean.Actions.Action)
  Macros.implement_enumerable(:actions, DigitalOcean.Actions)

  defmodule Action do
    @moduledoc """
    Single Digital Ocean Action Struct

    Its fields are:

      * `id` [integer] - unique identifier

      * `status` [string] - one of "in-progress", "completed", "errored"

      * `type` [string] - type of action represented

      * `started_at` [string] - ISO8601 when action was initiated

      * `completed_at` [string] - ISO8601 when action was completed

      * `resource_id` [integer] - id for the resouce action is associated with

      * `resource_type` [string] - type of resource action is associated with

      * `region` [string] - slug representing region where action occured

    See [the Digial Ocean Action
    documentation](https://developers.digitalocean.com/#actions) for
    full details.
    """
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

end
