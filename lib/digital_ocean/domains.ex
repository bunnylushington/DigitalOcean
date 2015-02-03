defmodule DigitalOcean.Domains do

  @derive [Access]
  require DigitalOcean.Macros, as: Macros
  import DigitalOcean.Util, only: [error_or_singleton: 3,
                                   expect_no_content: 1,
                                   raise_error_or_return: 1]

  defstruct(domains: [], links: %{}, meta: %{})
  @type t :: %__MODULE__{domains: [DigitalOcean.Domains.Domain],
                         links: DigitalOcean.links,
                         meta: DigitalOcean.meta}

  Macros.define_as_struct(:domains, DigitalOcean.Domains.Domain)
  Macros.implement_enumerable(:domains, DigitalOcean.Domains)

  @doc """
  Create a new domain record.

  The parameters are the domain name, which must be unique across all
  of Digital Ocean and an IP address to point the domain to.
  """
  @spec create(String.t, String.t) :: {:ok, DigitalOcean.Domains.Domain.t} |
                                      {:error, map}
  
  def create(name, ip) do
    DigOc.Domain.new!(name, ip)
    |> error_or_singleton(:domain, DigitalOcean.Domains.Domain)
  end

  @doc """
  Like `create/2` but raises DigitalOceanError.
  """
  @spec create!(String.t, String.t) :: DigitalOcean.Domains.Domain.t
  def create!(name, ip), do: create(name, ip) |> raise_error_or_return


  @doc """
  Delete a domain record.
  """
  @spec destroy(String.t) :: :ok | {:error, map}
  def destroy(name), do: DigOc.Domain.delete(name) |> expect_no_content

  @doc """
  Like `destroy/1` but raises DigitalOceanError.
  """
  @spec destroy(String.t) :: :ok
  def destroy!(name), do: destroy(name) |> raise_error_or_return
    
    
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
