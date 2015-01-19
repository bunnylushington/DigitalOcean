defmodule DigitalOcean do

  @per_page 100
  @no_content "204 No Content"
  
  @type page :: %{(:first | :last | :prev | :next) => String.t}
  @type pages :: %{} | %{:pages => page}
  @type links :: %{:links => pages}
  @type meta :: %{:meta => (%{} | %{:total => integer})}
  @type isotime :: String.t
  @type slug :: String.t


  # ------------------------------------------------------- ACCOUNT.
  @doc """
  Requests the account information associated with the current user.
  """
  @spec account() :: {:ok, DigitalOcean.Account.t} | {:error, map}
  def account do
    DigitalOcean.Account.as_struct(DigOc.account!)
  end

  @doc """
  Like `account/0` but raises DigitalOceanError.
  """
  @spec account!() :: DigitalOcean.Account.t
  def account!(), do: account |> raise_error_or_return
    
    
  # ------------------------------------------------------- ACTIONS.    
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
  @spec actions(integer) :: {:ok, DigitalOcean.Actions.t} | {:error, map}
  def actions(per_page \\ actions_per_page) do
    DigitalOcean.Actions.as_struct(DigOc.actions!(per_page))
  end

  @doc """
  Like `actions!/1` but raises DigitalOceanError.
  """
  @spec actions!(integer) :: DigitalOcean.Actions.t
  def actions!(per_page \\ actions_per_page) do
    actions(per_page) |> raise_error_or_return
  end
  
  @doc """
  Requests a specific action from the server.
  """
  @spec action(integer) :: ({:ok, DigitalOcean.Actions.Action.t} |
                            {:error, map})
  def action(id) do
    DigOc.action!(id)
    |> error_or_singleton(:action, DigitalOcean.Actions.Action)
  end

  @doc """
  Like `action/1` but raises DigitalOceanException.
  """
  @spec action!(integer) :: DigitalOcean.Actions.Action.t
  def action!(id), do: action(id) |> raise_error_or_return


    
  # ------------------------------------------------------- SSH KEYS.
  @doc """
  Requests the list of SSH keys from the server.  
  """
  @spec keys :: {:ok, DigitalOcean.Keys.t} | {:error, map}
  def keys do
    DigitalOcean.Keys.as_struct(DigOc.keys!)
  end

  @doc """
  Like `keys/0` but raises DigitalOceanError.
  """
  @spec keys! :: DigitalOcean.Keys.t
  def keys!(), do: keys |> raise_error_or_return

  @doc """
  Request one SSH key from the server.

  The parameter may be the key's id or fingerprint.
  """
  @spec key(integer | String.t) :: ({:ok, DigitalOcean.Keys.Key.t} |
                                    {:error, map})
  def key(id) do
    DigOc.key!(id) |> error_or_singleton(:ssh_key, DigitalOcean.Keys.Key)
  end

  @doc """
  Like `key/1` but raises DigitalOceanError.
  """
  @spec key!(integer | String.t) :: DigitalOcean.Keys.Key.t
  def key!(id), do: key(id) |> raise_error_or_return


  # ------------------------------------------------------- REGIONS.    
  @doc """
  Requests the list of regions from the server.
  """
  @spec regions :: {:ok, DigitalOcean.Regions.t} | {:error, map}
  def regions do
    DigitalOcean.Regions.as_struct(DigOc.regions!)
  end

  @doc """
  Like `regions/0` but raises DigitalOceanError.
  """
  @spec regions! :: DigitalOcean.Regions.t
  def regions!(), do: regions |> raise_error_or_return
    

  # ------------------------------------------------------- SIZES.
  @doc """
  Requests the list of sizes from the server.
  """
  @spec sizes :: {:ok, DigitalOcean.Sizes.t} | {:error, map}
  def sizes do
    DigitalOcean.Sizes.as_struct(DigOc.sizes!)
  end

  @doc """
  Like `sizes/0` but raises DigitalOceanError.
  """
  @spec sizes! :: DigitalOcean.Sizes.t
  def sizes!(), do: sizes |> raise_error_or_return


    

  def get_next_page(url, type) do
    apply(type, :as_struct, [DigOc.page!(url)]) |> raise_error_or_return
  end
      

  defp actions_per_page do
    Application.get_env(:digital_ocean, :actions_per_page, @per_page)
  end

  def raise_error_or_return(res) do
    case res do
      {:ok, struct} -> struct
      {:error, map} -> raise(DigitalOceanError, map)
    end
  end

  def expect_no_content({:ok, body, headers}) do
    if headers["Status"] == @no_content do
      :ok
    else
      {:error, body}
    end
  end
  def expect_no_content(_) do
    {:error, %{ id: "Undefined Error",
                message: "Cannot determine cause of error." }}
  end
    
  
  def error_or_singleton(result, key, type) do
    if DigitalOcean.Util.error?(result, key) do
      {:error, result}
    else
      {:ok, struct(type, result[key])}
    end
  end

end
