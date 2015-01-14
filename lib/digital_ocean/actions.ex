defmodule DigitalOcean.Actions do

  @derive [Access]
  require DigitalOcean.Macros, as: Macros

  defmodule Action do
    @derive [Access]

    defstruct(id: nil,
              status: nil,
              type: nil,
              started_at: nil,
              completed_at: nil,
              resource_id: nil,
              resource_type: nil,
              region: nil)
  end

  defstruct(actions: [], links: %{}, meta: %{})
  Macros.define_as_struct(:actions, DigitalOcean.Actions.Action)

  end
