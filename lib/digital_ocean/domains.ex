defmodule DigitalOcean.Domains do

  @derive [Access]
  require DigitalOcean.Macros, as: Macros

  defstruct(domains: [], links: %{}, meta: %{})
  @type t :: %__MODULE__{domains: [DigitalOcean.Domains.Domain],
                         links: DigitalOcean.links,
                         meta: DigitalOcean.meta}

  Macros.define_as_struct(:domains, DigitalOcean.Domains.Domain)
  Macros.implement_enumerable(:domains, DigitalOcean.Domains)

  defmodule Domain do
    @moduledoc """
    Digital Ocean Domain Struct

    Its fields are 

      * `name` [string] - name of the domain

      * `ttl` [integer] - time to live for domain records (seconds)

      * `zone_file` [string] - complete contents of the zone file

    See the [Digital Ocean Domains
    documentation](https://developers.digitalocean.com/#domains) for
    further details.
    """
    @derive [Access]

    defstruct(name: nil, ttl: nil, zone_file: nil)
    @type t :: %__MODULE__{name: String.t, ttl: integer, zone_file: String.t}
  end 
end
