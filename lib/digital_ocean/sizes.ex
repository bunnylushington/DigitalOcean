defmodule DigitalOcean.Sizes do
  @derive [Access]

  defmodule Size do
    @derive [Access]
    defstruct(disk:          nil,
              memory:        nil,
              price_hourly:  nil,
              price_monthly: nil,
              regions:       [],
              slug:          nil,
              transfer:      nil,
              vcpus:         nil)
  end

  defstruct(sizes: [], links: %{}, meta: %{})

  def as_struct(data) do
    s = struct(__MODULE__, data)
    size_list = Enum.map(s.sizes,
      fn(x) -> struct(DigitalOcean.Sizes.Size, x) end)
    %{ s | sizes: size_list }
  end
    
end

# ------------------------- Protocol Implementations.

defimpl Collectable, for: DigitalOcean.Sizes do
  def into(original) do
    {[], fn
      list, {:cont, x} -> [x|list]
      list, :done -> original ++ :lists.reverse(list)
      _, :halt -> :ok
    end}
  end
end


defimpl Enumerable, for: DigitalOcean.Sizes do
  def count(c) do
    {:ok, length(c.sizes)}
  end

  def member?(c, v) do
    {:ok, Enum.any?(c.sizes, fn(x) -> x.slug == v end)}
  end

  def reduce(_sizes, {:halt, acc}, _fun), do: {:halted, acc}
  def reduce(sizes, {:suspend, acc}, fun) do
    {:suspended, acc, &reduce(sizes, &1, fun)}
  end
  def reduce(%DigitalOcean.Sizes{sizes: []}, {:cont, acc}, _fun) do
    {:done, acc}
  end
  def reduce(%DigitalOcean.Sizes{sizes: [h|t]} = s, {:cont, acc}, fun) do
    reduce(%{ s | sizes: t }, fun.(h, acc), fun)
  end
end
