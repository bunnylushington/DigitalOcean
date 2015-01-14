defmodule DigitalOcean do

  @doc """
  Returns %DigitalOcean.Account{}.
  """
  def account do
    DigitalOcean.Account.as_struct(DigOc.account!)
  end

  
  @doc """
  Returns %DigitalOcean.Regions{}.
  """
  def regions do
    DigitalOcean.Regions.as_struct(DigOc.regions!)
  end

  
  @doc """
  Returns %DigitalOcean.Sizes{}.  
  """
  def sizes do
    DigitalOcean.Sizes.as_struct(DigOc.sizes!)
  end


  
end
