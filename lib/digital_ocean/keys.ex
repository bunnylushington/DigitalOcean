defmodule DigitalOcean.Keys do
  @moduledoc """
  Manipulate SSH Public Keys

  See the [Digital Ocean
  documentation](https://developers.digitalocean.com/#ssh-keys) for
  further information.  

  """
  
  @derive [Access]
  require DigitalOcean.Macros, as: Macros
  import DigitalOcean, only: [error_or_singleton: 3,
                              expect_no_content: 1,
                              raise_error_or_return: 1]

  defstruct(ssh_keys: [], links: %{}, meta: %{})
  @type t :: %__MODULE__{ssh_keys: [DigitalOcean.Keys.Key.t],
                         links: DigitalOcean.links,
                         meta: DigitalOcean.meta}

  Macros.define_as_struct(:ssh_keys, DigitalOcean.Keys.Key)
  Macros.implement_enumerable(:ssh_keys, DigitalOcean.Keys)

  @doc """
  Create a new public key.

  The first argument is a human readable name.  The second argument
  may be the literal text of the key or the 2-tuple `{:file, filename}` 
  where `filename` is the path to a public SSH key.
  """
  @spec create(String.t, (String.t |
                          {:file, String.t})) :: DigitalOcean.Keys.Key.t
  def create(name, {:file, filename}) do
    case File.read(filename) do
      {:ok, key} -> create(name, key)
      error -> error
    end
  end

  def create(name, key) do
    DigOc.Key.new!(name, key)
    |> error_or_singleton(:ssh_key, DigitalOcean.Keys.Key)
  end

  @doc """
  Like `create/2` but raises error.
  """
  @spec create!(String.t, (String.t |
                          {:file, String.t})) :: DigitalOcean.Keys.Key.t
  def create!(name, {:file, filename}), do: create!(name, File.read!(filename))
  def create!(name, key), do: create(name, key) |> raise_error_or_return

  @doc """
  Update a public SSH key.

  The first parameter may be either the existing key's ID or
  fingerprint.  The second parameter is the new name.
  """
  @spec update((String.t | integer), String.t) ::
    {:ok, DigitalOcean.Keys.Key.t} | {:error, map}
  def update(id, name) do
    DigOc.Key.update!(id, name)
    |> error_or_singleton(:ssh_key, DigitalOcean.Keys.Key)
  end

  @doc """
  Like `update/2` but raises error.
  """
  def update!(id, name), do: update(id, name) |> raise_error_or_return

  @doc """
  Destroy a public SSH key.

  The parameter is an existing key's ID or fingerprint.
  """
  @spec destroy(String.t | integer) ::
    ({:ok, DigitalOcean.Keys.Key.t} | {:error, map })
  def destroy(id) do
    DigOc.Key.destroy(id) |> expect_no_content
  end

  @doc """
  Like `destroy/1` but raises error.
  """
  @spec destroy!(String.t | integer) :: DigitalOcean.Keys.Key.t
  def destroy!(id), do: destroy(id) |> raise_error_or_return
    
 
    
  defmodule Key do
    @moduledoc """
    Single SSH Public Key Struct

    Its fields are:

      * `id` [integer] - unique identifier
  
      * `fingerprint` [string] - unique value generated from the key

      * `public_key` [string] - the key text itself

      * `name` [string] - human readable display name

    """
    @derive [Access]
    defstruct(id:          nil,
              fingerprint: nil,
              public_key:  nil,
              name:        nil)

    @type t :: %__MODULE__{id: integer,
                           fingerprint: String.t,
                           public_key: String.t,
                           name: String.t}
  end
end
