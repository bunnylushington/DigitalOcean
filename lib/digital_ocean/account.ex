defmodule DigitalOcean.Account do

  @derive [Access]
  require DigitalOcean.Macros, as: Macros

  defstruct(droplet_limit:  nil,
            email:          nil,
            uuid:           nil,
            email_verified: nil)

  def as_struct(data) do
    %__MODULE__{droplet_limit:  data.account.droplet_limit,
                email:          data.account.email,
                uuid:           data.account.uuid,
                email_verified: data.account.email_verified}
  end
  
end
