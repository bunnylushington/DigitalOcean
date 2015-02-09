defmodule DigitalOcean.Kernels do

  @derive [Access]
  require DigitalOcean.Macros, as: Macros

  defstruct(kernels: [], links: %{}, meta: %{})

  @type t :: %__MODULE__{kernels: [DigitalOcean.Kernels.Kernel.t],
                         links: DigitalOceanlinks,
                         meta: DigitalOcean.meta}

  Macros.define_as_struct(:kernels, DigitalOcean.Kernels.Kernel)
  Macros.implement_enumerable(:kernels, DigitalOcean.Kernels)

  
  defmodule Kernel do
    @moduledoc """
    Digital Ocean Kernel Struct
   
    Its fields are

       * `id` [integer]
   
       * `name` [string]

       * `version` [string]    
    """

    @derive [Access]
    defstruct(id: nil, name: nil, version: nil)
    @type t :: %__MODULE__{id: integer, name: String.t, version: String.t}

    def as_struct(data), do: struct(__MODULE__, data)
    
  end
end
  
