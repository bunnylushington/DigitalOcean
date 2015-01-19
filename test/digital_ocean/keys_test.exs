defmodule DigitalOcean.KeysTest do
  use ExUnit.Case

  setup do
    {key_data, _} = Code.eval_file("test/sample-data/keys", System.cwd)
    pubkey = Path.join(System.cwd, "test/sample-data/public-key")
    {:ok, fixtures: key_data, pubkey: pubkey}
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

  @tag :external
  test "retrieve keys" do
    s = DigitalOcean.keys!
    assert {:ok, ^s} = DigitalOcean.keys
    assert Enum.count(s) == length(s[:ssh_keys])
  end

  @tag :external
  test "retrieve a single valid key" do
    key = hd(DigitalOcean.keys![:ssh_keys])
    #IO.puts inspect key.fingerprint
    assert ^key = DigitalOcean.key!(key.id)
    assert ^key = DigitalOcean.key!(key.fingerprint)
    assert {:ok, ^key} = DigitalOcean.key(key.id)
  end

  @tag :external
  test "retrieve a single invalid key" do
    assert {:error, _} = DigitalOcean.key(1)
    assert_raise DigitalOceanError, fn -> DigitalOcean.action!(1) end
  end

  @tag :external
  test "create, update, and delete a new key", %{ pubkey: pubkey } do
    newkey = DigitalOcean.Keys.create!("newkey", {:file, pubkey})
    assert newkey.__struct__ == DigitalOcean.Keys.Key
    updated_key = DigitalOcean.Keys.update!(newkey.id, "renamed-key")
    assert updated_key.id == newkey.id
    assert updated_key.name == "renamed-key"
    assert :ok = DigitalOcean.Keys.destroy(newkey.id)
  end

end
