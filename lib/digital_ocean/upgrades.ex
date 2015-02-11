defmodule DigitalOcean.Upgrades do

  @type t :: [DigitalOcean.Upgrades.Upgrade.t]

  def as_list(data) do
    for u <- data, do: struct(DigitalOcean.Upgrades.Upgrade, u)
  end
    
  
  defmodule Upgrade do
    @moduledoc """
    Single Digital Ocean Upgrade Struct

    Its fiels are:
  
      * `droplet_id` [integer]

      * `date_of_migration` [string]

      * `url` [string]
    """
    @derive [Access]
    defstruct(droplet_id: nil, date_of_migration: nil, url: nil)
    @type t :: %__MODULE__{droplet_id: integer,
                           date_of_migration: DigitalOcean.isotime,
                           url: String.t}
  end
end
