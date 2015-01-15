defmodule DigitalOcean.Util do

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
  
end
