defmodule DigitalOcean.Networks do

  @derive [Access]
  defstruct(v4: [], v6: [])
  @type t :: %__MODULE__{v4: [DigitalOcean.Networks.Network.t],
                         v6: [DigitalOcean.Networks.Network.t]}

  def as_struct(data) do
    struct(__MODULE__,
           Enum.map(data,
             fn({k, v}) -> {k, Enum.map(v, fn(x) -> network(x) end)} end))
  end

  defp network(m), do: struct(DigitalOcean.Networks.Network, m)
  
  defmodule Network do
    @moduledoc """
    A Digital Ocean Network struct.

    Its fields are

      * `gateway` [string]
   
      * `ip_address` [string]

      * `netmask` [string]

      * `type` [string] - "public" or "private"
    """

    @derive [Access]
    defstruct(gateway: nil, ip_address: nil, netmask: nil, type: nil)
    @type t :: %__MODULE__{gateway: String.t,
                           ip_address: String.t,
                           netmask: String.t,
                           type: String.t}
  end
end
                           
