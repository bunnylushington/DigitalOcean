defmodule DigitalOcean do

  @per_page 100

  
  @doc """
  Returns %DigitalOcean.Account{}.
  """
  def account do
    DigitalOcean.Account.as_struct(DigOc.account!)
  end


  @doc """
  Returns %DigitalOcean.Actions{}.
  """
  def actions(per_page \\ actions_per_page) do
    DigitalOcean.Actions.as_struct(DigOc.actions!(per_page))
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


  defp actions_per_page do
    Application.get_env(:digital_ocean, :actions_per_page, @per_page)
  end
  
end
