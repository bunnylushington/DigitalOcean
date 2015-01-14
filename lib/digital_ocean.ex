defmodule DigitalOcean do

  @doc """
  Returns %DigitalOcean.Sizes{}.  
  """
  def sizes do
    DigitalOcean.Sizes.as_struct(DigOc.sizes!)
  end


  @doc """
  Returns %DigitalOcean.Regions{}.
  """
  def regions do
    DigitalOcean.Regions.as_struct(DigOc.regions!)
  end
  
end
