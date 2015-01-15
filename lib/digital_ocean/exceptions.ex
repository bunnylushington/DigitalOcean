defmodule DigitalOceanError do
  defexception [:message]
  
  def exception(value) do
    msg = "#{ value.message } (#{ value.id })"
    %__MODULE__{message: msg}
  end

end
