defmodule DigitalOcean do

  @per_page 100

  @type page :: %{(:first | :last | :prev | :next) => String.t}
  @type pages :: %{} | %{:pages => page}
  @type links :: %{:links => pages}
  @type meta :: %{:meta => (%{} | %{:total => integer})}
  @type isotime :: String.t
  @type slug :: String.t
  
  @doc """
  Requests the account information associated with the current user.
  """
  @spec account() :: DigitalOcean.Account.t
  def account do
    DigitalOcean.Account.as_struct(DigOc.account!)
  end


  @doc """ 
  Requests actions associated with the account.  

  Actions are events that have occured on resources (e.g., rebooting a
  droplet).

  The number of actions returned will depend on a number of factors.
  If an argument is passed to `actions/1` that value takes precedent.
  If the configuration item `:actions_per_page` is set, that value
  will be used.  Failing that, the default value will be 100 items.

  Note that the server side may impose its own limit.  At the time of
  writing that limit appears to be 200.

  The struct that is returned adheres to the Enumerable protocol.
  What this means exactly depends on the configuration item
  `:use_api_paging`.  If set to `false` the enumeration will consider
  _only_ the actions returned with the current request.  That's to
  say that

      iex> DigitalOcean.actions(10) |> Enum.count
      10

  If, however `:use_api_paging` is `true` the count might be greater
  than the number of Action items (it will be the value returned by
  the server side).  If that's the case executing some Enum actions
  (though not `Enum.count/1`) to request additional pages from the
  server.  Thus it's possible to iterate through _all_ of the
  actions but might require multiple HTTP requests.

  """
  @spec actions(integer) :: DigitalOcean.Actions.t
  def actions(per_page \\ actions_per_page) do
    DigitalOcean.Actions.as_struct(DigOc.actions!(per_page))
  end


  @doc """
  Requests a specific action from the server.
  """
  @spec action(integer) :: ({:ok, DigitalOcean.Actions.Action.t} |
                            {:error, any})
  def action(id) do
    a = DigOc.action!(id)
    if Map.has_key?(a, :action) do
      {:ok, struct(DigitalOcean.Actions.Action, a.action)}
    else
      {:error, a}
    end
  end
  
  @doc """
  Like `action/1` but returns the Action struct directly or raises a
  DigitalOceanException on error.
  """
  @spec action!(integer) :: DigitalOcean.Actions.Action.t
  def action!(id) do
    case action(id) do
      {:ok, result} -> result
      {:error, err} -> raise DigitalOceanError, err
    end
  end
  
  
  @doc """
  Requests the list of regions from the server.
  """
  @spec regions :: DigitalOcean.Regions.t
  def regions do
    DigitalOcean.Regions.as_struct(DigOc.regions!)
  end

  
  @doc """
  Requests the list of sizes from the server.
  """
  @spec sizes :: DigitalOcean.Sizes.t
  def sizes do
    DigitalOcean.Sizes.as_struct(DigOc.sizes!)
  end


  defp actions_per_page do
    Application.get_env(:digital_ocean, :actions_per_page, @per_page)
  end
  
end
