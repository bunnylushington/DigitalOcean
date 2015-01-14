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
        def count(c), do: {:ok, length(c[unquote(key)])}

        def member?(c, v) when is_binary(v) do
          {:ok, Enum.any?(c[unquote(key)], fn(x) -> x.slug == v end) }
        end

        def member?(c, v) when is_integer(v) do
          {:ok, Enum.any?(c[unquote(key)], fn(x) -> x.id == v end) }
        end

        def reduce(_, {:halt, acc}, _), do: {:halted, acc}
        def reduce(c, {:suspend, acc}, fun) do
          {:suspended, acc, &reduce(c, &1, fun)}
        end
        def reduce(%{unquote(key) => []}, {:cont, acc}, _fun) do
          {:done, acc}
        end
        def reduce(%{unquote(key) => [h|t]} = c, {:cont, acc}, fun) do
          reduce(%{ c | unquote(key) => t }, fun.(h, acc), fun)
        end
      end
    end
  end
  
end
