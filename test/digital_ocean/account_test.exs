defmodule DigitalOcean.AccountTest do
  use ExUnit.Case

  test "account struct correct" do
    s = %DigitalOcean.Account{}
    assert s.droplet_limit == nil
    assert s.email == nil
    assert s.uuid == nil
    assert s[:email_verified] == nil
  end

  @tag :external
  test "retrieve and populate account" do
    s = DigitalOcean.account
    assert is_integer(s.droplet_limit)
    assert is_binary(s.email)
    assert is_binary(s.uuid)
    assert is_boolean(s.email_verified)
  end
  
end
