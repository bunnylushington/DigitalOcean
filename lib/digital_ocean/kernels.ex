defmodule DigitalOcean.Kernels do
  
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
  
