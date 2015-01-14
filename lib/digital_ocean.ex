defmodule DigitalOcean do

  @doc """
  Returns %DigitalOcean.Sizes{}.  
  """
  def sizes do
    DigitalOcean.Sizes.as_struct(DigOc.sizes!)
  end
  
end
