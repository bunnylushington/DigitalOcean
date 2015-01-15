defmodule DigitalOcean.Macros do

  defmacro define_as_struct(key, type) do
    quote do
      def as_struct(data) do
        s = struct(__MODULE__, data)
        list = Enum.map(s[unquote(key)],
          fn(x) -> struct(unquote(type), x) end)
        %{ s | unquote(key) => list }
      end
    end
  end

  defmacro implement_enumerable(key, type) do
    quote do
      defimpl Enumerable, for: unquote(type) do

        def count(c) do
          if Application.get_env(:digital_ocean, :use_api_paging, false) do
            {:ok, c.meta.total}
          else
            {:ok, length(c[unquote(key)])}
          end
        end
        
        
        def member?(c, v) when is_integer(v) do
          {:ok, Enum.any?(c[unquote(key)], fn(x) -> x.id == v end) }
        end
        
        def member?(c, v) when is_binary(v) do
          {:ok, Enum.any?(c[unquote(key)], fn(x) -> x.slug == v end) }
        end

        
        def reduce(_, {:halt, acc}, _), do: {:halted, acc}
          
        def reduce(c, {:suspend, acc}, fun) do
          {:suspended, acc, &reduce(c, &1, fun)}
        end
        
        def reduce(%{unquote(key) => []} = c, {:cont, acc}, fun) do
          if (Map.has_key?(c.links, :pages)
              && Map.has_key?(c.links.pages, :next)
              && Application.get_env(:digital_ocean, :use_api_paging, false)) do
            c = apply(unquote(type), :get_next_page, [c.links.pages.next])
            reduce(c, {:cont, acc}, fun)
          else
            {:done, acc}
          end
        end

        def reduce(%{unquote(key) => [h|t]} = c, {:cont, acc}, fun) do
          reduce(%{ c | unquote(key) => t }, fun.(h, acc), fun)
        end
      end
    end
  end
  
end
