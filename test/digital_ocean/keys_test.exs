defmodule DigitalOcean.KeysTest do
  use ExUnit.Case

  setup do
    {key_data, _} = Code.eval_file("test/sample-data/keys", System.cwd)
    {:ok, fixtures: key_data}
  end

  test "key struct created from fixture", %{ fixtures: keys } do
    data = hd(keys.ssh_keys)
    s = struct(DigitalOcean.Keys.Key, data)
    assert s[:id] == 79152
    assert s.name == "keyone"
  end

  test "keys struct created from fixture", %{ fixtures: keys } do
    s = struct(DigitalOcean.Keys, keys)
    assert length(s.ssh_keys) == s.meta[:total]
    assert s.links == %{}
  end

  test "struct and embedded structs created", %{ fixtures: keys } do
    {:ok, s} = DigitalOcean.Keys.as_struct(keys)
    assert length(s.ssh_keys) == s.meta[:total]
    key = hd(s.ssh_keys)
    assert key.__struct__ == DigitalOcean.Keys.Key
    assert key.name == "keyone"
  end
  
  test "keys as enumeration", %{ fixtures: keys } do
    {:ok, s} = DigitalOcean.Keys.as_struct(keys)
    assert Enum.count(s) == s.meta[:total]
    assert Enum.member?(s, "keyone")
    refute Enum.member?(s, "keysix")
  end

  test "as an iteration", %{ fixtures: keys } do
    {:ok, s} = DigitalOcean.Keys.as_struct(keys)
    res = for _ <- s, do: :ok
    assert res == List.duplicate(:ok, Enum.count(s))
  end

end
