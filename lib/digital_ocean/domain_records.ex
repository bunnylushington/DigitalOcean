defmodule DigitalOcean.DomainRecords do

  @derive [Access]
  require DigitalOcean.Macros, as: Macros
  import DigitalOcean.Util, only: [error_or_singleton: 3,
                                   expect_no_content: 1,
                                   raise_error_or_return: 1]


  defstruct(domain_records: [], links: %{}, meta: %{})
  @type t :: %__MODULE__{domain_records: [DigitalOcean.DomainRecords.Record],
                         links: DigitalOcean.links,
                         meta: DigitalOcean.meta}

  Macros.define_as_struct(:domain_records, DigitalOcean.DomainRecords.Record)
  Macros.implement_enumerable(:domain_records, DigitalOcean.DomainRecords)

  @doc """
  Request that a new record be created in the domain. 
  """
  @spec create(String.t, DigitalOcean.DomainRecords.Record.t) ::
    {:ok, DigitalOcean.DomainRecords.Record.t} | {:error, map}
  def create(domain, record) do
    DigOc.Domain.Record.new!(domain, record)
    |> error_or_singleton(:domain_record, DigitalOcean.DomainRecords.Record)
  end

  @doc """
  Like `create/2` but raises DigitalOceanError
  """
  @spec create!(String.t, DigitalOcean.DomainRecords.Record.t) ::
    DigitalOcean.DomainRecords.Record.t
  def create!(domain, record) do
    create(domain, record) |>  raise_error_or_return
  end

  @doc """
  Update the name of a domain record.
  """
  @spec update(String.t, integer, String.t|DigitalOcean.DomainRecords.Record.t)
    :: {:ok, DigitalOcean.DomainRecords.Record.t} | {:error, map}
  def update(domain, id, name) when is_binary(name) do
    DigOc.Domain.Record.update!(domain, id, name)
    |> error_or_singleton(:domain_record, DigitalOcean.DomainRecords.Record)
  end

  def update(domain, id, rec) when is_map(rec) do
    update(domain, id, rec.name)
  end

  @doc """
  Like `update/3` but raises DigitalOceanError.
  """
  @spec update(String.t, integer, String.t|DigitalOcean.DomainRecords.Record.t)
    :: DigitalOcean.DomainRecords.Record.t
  def update!(domain, id, rec_or_name) do
    update(domain, id, rec_or_name) |> raise_error_or_return
  end

  @doc """
  Delete a domain record.
  """
  @spec destroy(String.t, integer | DigitalOcean.DomainRecords.Record.t) ::
    :ok | {:error, map}
  def destroy(domain, id) when is_integer(id) do
    DigOc.Domain.Record.delete(domain, id) |> expect_no_content
  end

  def destroy(domain, rec) when is_map(rec), do: destroy(domain, rec.id)

  @doc """
  Like `destroy/2` but raises DigitalOceanError.
  """
  @spec destroy!(String.t, integer | DigitalOcean.DomainRecords.Record.t) :: :ok
  def destroy!(domain, rec_or_id) do
    destroy(domain, rec_or_id) |> raise_error_or_return
  end
  
  
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
