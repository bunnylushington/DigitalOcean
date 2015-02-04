defmodule DigitalOcean.Droplets do
  
  @derive [Access]
  require DigitalOcean.Macros, as: Macros

  defstruct(droplets: [], links: %{}, meta: %{})

  @type t :: %__MODULE__{droplets: [DigitalOcean.Droplets.Droplet.t],
                         links: DigitalOcean.links,
                         meta: DigitalOcean.meta}

  #  Macros.define_as_struct(:droplets, DigitalOcean.Droplets.Droplet)
  Macros.implement_enumerable(:droplets, DigitalOcean.Droplets)

  

  defmodule Droplet do
    @moduledoc """
    Single Digital Ocean Droplet Struct

    Its fields are: 

      * `id` [integer] - unique identifier
    
      * `name` [string] - human readable name

      * `memory` [integer] - amt of memory in MB

      * `vcpus` [integer] - number of virtual CPUs

      * `disk` [integer] - size of the droplet's disk in GB

      * `locked` [boolean] - indicates droplet lock status

      * `created_at` [string] - when the droplet was created

      * `status` [string] - "new", "active", "off", or "archive"

      * `backup_ids` [ary of integers] - backup IDs of the instance

      * `snapshot_ids` [ary of integers] - snapshot IDs of the instance

      * `features` [ary of strings] - enabled features

      * `region` [region obj] - region droplet is deployed in

      * `image` [image obj] - base image used to create droplet

      * `size` [string] - size slug
   
      * `networks` [network obj] - network details

      * `kernel` [network obj] - the current kernel


    See [the Digital Ocean Droplets
    documentation](https://developers.digitalocean.com/#droplets) for
    full details.
    """
    @derive [Access]
    defstruct(id: nil,
              name: nil,
              memory: nil,
              vcpus: nil,
              disk: nil,
              locked: nil,
              created_at: nil,
              status: nil,
              backup_ids: [],
              snapshot_ids: [],
              features: [],
              region: nil,
              image: nil,
              size: nil,
              networks: nil,
              kernel: nil)

    def as_struct(data) do
      struct(__MODULE__, data)
    end
  end
              
  
end
