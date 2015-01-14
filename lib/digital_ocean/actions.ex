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

  def get_next_page(url), do: as_struct(DigOc.page!(url))


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

    # item list is empty, maybe retrieve the next page
    def reduce(%{:actions => []} = c, {:cont, acc}, fun) do
      if (Map.has_key?(c.links, :pages)
          && Map.has_key?(c.links.pages, :next)
          && Application.get_env(:digital_ocean, :use_api_paging, false)) do
        c = DigitalOcean.Actions.get_next_page(c.links.pages.next)
        reduce(c, {:cont, acc}, fun)
      else
        {:done, acc}
      end
    end

    # draining down the entry list
    def reduce(%{:actions => [h|t]} = c, {:cont, acc}, fun) do
      reduce(%{ c | :actions => t }, fun.(h, acc), fun)
    end
  end
  
end
