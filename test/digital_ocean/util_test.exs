defmodule DigitalOcean.UtilTest do
  use ExUnit.Case

  test "determine errors" do
    # errors
    m1 = %{ key: "", id: "Not Found", message: "an error" }
    m2 = %{ key: [], id: "Not Found", message: "an error" }
    assert DigitalOcean.Util.error?(m1, :key)
    assert DigitalOcean.Util.error?(m2, :key)
    
    # not errors
    m3 = %{ key: "quux", id: "Found", message: "not an error" }
    m4 = %{ key: [1, 2, 3], id: "Found", message: "not an error" }
    m5 = %{ key: "", id: "not error" }
    m6 = %{ key: [], message: "not error" }
    refute DigitalOcean.Util.error?(m3, :key)
    refute DigitalOcean.Util.error?(m4, :key)
    refute DigitalOcean.Util.error?(m5, :key)
    refute DigitalOcean.Util.error?(m6, :key)
  end
    
    
  
end
