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


  defimpl Enumerable, for: __MODULE__ do
    def count(c) do
      case Application.get_env(:digital_ocean, :use_api_paging, false) do
        true -> {:ok, c.meta.total}
        false -> {:ok, length(c.actions) }
      end
    end
      
    def member?(c, v) do
      {:ok, Enum.any?(c.actions, fn(x) -> x.id == v end) }
    end
    
    def reduce(_, {:halt, acc}, _), do: {:halted, acc}
    def reduce(c, {:suspend, acc}, fun) do
      {:suspended, acc, &reduce(c, &1, fun)}
    end

    # item list is empty but there's an additional page
    def reduce(%{:actions => [], :links => %{:pages => %{:next => _next}}},
               {:cond, acc}, _fun) do
      case Application.get_env(:digital_ocean, :use_api_paging, false) do
        true -> :not_implemented
        false -> {:done, acc}
      end
    end

    # item list is empty, no next page
    def reduce(%{:actions => []}, {:cont, acc}, _fun) do
      {:done, acc}
    end

    # draining down the entry list
    def reduce(%{:actions => [h|t]} = c, {:cont, acc}, fun) do
      reduce(%{ c | :actions => t }, fun.(h, acc), fun)
    end
  end
  
end
