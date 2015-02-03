defmodule DigitalOcean.DomainRecords do

  @derive [Access]
  require DigitalOcean.Macros, as: Macros

  defstruct(domain_records: [], links: %{}, meta: %{})
  @type t :: %__MODULE__{domain_records: [DigitalOcean.DomainRecords.Record],
                         links: DigitalOcean.links,
                         meta: DigitalOcean.meta}

  Macros.define_as_struct(:domain_records, DigitalOcean.DomainRecords.Record)
  Macros.implement_enumerable(:domain_records, DigitalOcean.DomainRecords)

  defmodule Record do
    @moduledoc """
    Digital Ocean Domain Record Struct

    Its fields are

      * `id` [integer] - unique identifier

      * `type` [string] - type of DNS record

      * `name` [string] - name of the DNS record

      * `data` [string] - value of the DNS record

      * `priority` [integer] - priority for SRV and MX records

      * `port` [integer] - port for SRV records

      * `weight` [integer] - weight for SRV records

    See the [Digital Ocean Domain Records
    documentation](https://developers.digitalocean.com/#domain-records)
    for further details.

    """
    @derive [Access]

    defstruct(id: nil, type: nil, name: nil, data: nil, priority: nil,
              port: nil, weight: nil)
    @type t :: %__MODULE__{id: integer,
                           type: String.t,
                           name: String.t,
                           data: String.t,
                           priority: integer,
                           port: integer,
                           weight: integer}
  end
  
end
