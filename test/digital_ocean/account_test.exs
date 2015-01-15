defmodule DigitalOcean.AccountTest do
  use ExUnit.Case

  setup do
    {account_data, _} = Code.eval_file("test/sample-data/account", System.cwd)
    {:ok, fixtures: account_data}
  end
  
  test "account struct created from fixture", %{ fixtures: account } do
    {:ok, s} = DigitalOcean.Account.as_struct(account)
    assert s.droplet_limit == 25
    assert s.email == "quuxor@example.com"
    assert s.uuid == "cdbdbsabzb"
    assert s[:email_verified] == true
  end

  @tag :external
  test "retrieve and populate account" do
    s = DigitalOcean.account!
    {:ok, ^s} = DigitalOcean.account
    assert is_integer(s.droplet_limit)
    assert is_binary(s.email)
    assert is_binary(s.uuid)
    assert is_boolean(s.email_verified)
  end
  
end
