defmodule DigitalOcean.Util do

  @no_content "204 No Content"
  
  @doc """ 
  Try to determine if a result represents an error condition.

  `data` is the result of a DigOc.x! call; `key` is where the results
  are expected (e.g., :sizes or :regions).
  """
  @spec error?(map, atom) :: boolean
  def error?(data, key) do
    lacking_key_data(data, key) && has_error_keys(data)
  end

  defp lacking_key_data(data, key) do
    (not Map.has_key?(data, key)) || data[key] == [] || data[key] == ""
  end
  
  defp has_error_keys(data) do
    Enum.all? [:id, :message], fn(key) -> Map.has_key?(data, key) end
  end


  @doc """
  Given a URL mined from the `:links[:pages]` map, fetch that URL and
  cast the result into a struct of type TYPE.  This function is used
  by the Enumerable implementation that's included with most types.
  """
  def get_next_page(url, type) do
    apply(type, :as_struct, [DigOc.page!(url)]) |> raise_error_or_return
  end

  @doc """ 
  Given the result of X.as_struct/1 either return the struct or raise
  a DigitalOceanError.  Used by the "bang" versions of functions where
  an error, rather than a tagged tuple, is expected.
  """
  def raise_error_or_return(res) do
    case res do
      :ok -> :ok
      {:ok, struct} -> struct
      {:error, map} -> raise(DigitalOceanError, map)
    end
  end

  @doc """
  Given a full DigOc result (i.e., not the abbreviated body-only
  result returned by the "bang" versions of functions) return `:ok` if
  the result indicates that `204 No Content` was returned (but the
  request was successful) and `{:error, any}` otherwise.
  """
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

  @doc """

  Given a result body (i.e., what DigOc body-only results return)
  return either `{:ok, struct}` or `{:error, result}`.

  Example:
      error_or_singleton(res, :accounts, DigitalOcean.Accounts.Account)

  """
  def error_or_singleton(result, key, type) do
    if DigitalOcean.Util.error?(result, key) do
      {:error, result}
    else
      if DigitalOcean.Macros.as_struct_implemented(type) do
        {:ok, apply(type, :as_struct, [result[key]])}
      else
        {:ok, struct(type, result[key])}
      end
    end
  end

end
