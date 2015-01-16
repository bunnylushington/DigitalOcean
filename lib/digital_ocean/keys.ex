defmodule DigitalOcean.Keys do

  @derive [Access]
  require DigitalOcean.Macros, as: Macros

  defmodule Key do
    @derive [Access]
    defstruct(id:          nil,
              fingerprint: nil,
              public_key:  nil,
              name:        nil)

    @type t :: %__MODULE__{id: integer,
                           fingerprint: String.t,
                           public_key: String.t,
                           name: String.t}

  end

  defstruct(ssh_keys: [], links: %{}, meta: %{})
  @type t :: %__MODULE__{ssh_keys: [DigitalOcean.Keys.Key.t],
                         links: DigitalOcean.links,
                         meta: DigitalOcean.meta}

  Macros.define_as_struct(:ssh_keys, DigitalOcean.Keys.Key)
  Macros.implement_enumerable(:ssh_keys, DigitalOcean.Keys)
  
end
