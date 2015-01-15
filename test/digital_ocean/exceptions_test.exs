defmodule DigitalOceanErrorTest do
  use ExUnit.Case

  test "able to raise D.O. Error" do
    message = "This is the message."
    id = "Not Found"
    assert_raise DigitalOceanError, "#{ message } (#{ id })",
      fn -> raise DigitalOceanError, %{ message: message, id: id } end
  end
  
end
