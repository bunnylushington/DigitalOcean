defmodule DigitalOcean.Account do

  @derive [Access]

  defstruct(droplet_limit:  nil,
            email:          nil,
            uuid:           nil,
            email_verified: nil)
  
  @type t :: %__MODULE__{droplet_limit:  integer,
                         email:          String.t,
                         uuid:           String.t,
                         email_verified: boolean }

  def as_struct(data) do
    if DigitalOcean.Util.error?(data, :uukd) do
      {:error, data}
    else
      {:ok, %__MODULE__{droplet_limit:  data.account.droplet_limit,
                        email:          data.account.email,
                        uuid:           data.account.uuid,
                        email_verified: data.account.email_verified}}
    end
  end
  
end
