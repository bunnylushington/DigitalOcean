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
  Returns {:ok, %DigitalOcean.Actions.Action{}} or {:error, result}
  """
  def action(id) do
    a = DigOc.action!(id)
    if Map.has_key?(a, :action) do
      {:ok, struct(DigitalOcean.Actions.Action, a.action)}
    else
      {:error, a}
    end
  end


  def action!(id) do
    case action(id) do
      {:ok, result} -> result
      {:error, err} -> raise DigitalOceanError, err
    end
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
