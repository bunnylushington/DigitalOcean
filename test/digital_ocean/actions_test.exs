defmodule DigitalOcean.ActionsTest do
  use ExUnit.Case

  setup do
    {action_data, _} = Code.eval_file("test/sample-data/actions", System.cwd)
    {:ok, fixtures: action_data}
  end
  
  test "action struct exists" do
    s = %DigitalOcean.Actions.Action{}
    assert s.id == nil
    assert s.type == nil
    assert s[:region] == nil
  end

  test "action struct created from fixture", %{ fixtures: actions } do
    data = hd(actions.actions)
    s = struct(DigitalOcean.Actions.Action, data)
    assert s.status == "completed"
    assert s[:resource_type] == "droplet"
  end
  
  test "actions struct created from fixture", %{ fixtures: actions } do
    s = struct(DigitalOcean.Actions, actions)
    assert length(s.actions) == 3
    refute s.links == %{}
    assert s.meta[:total] == 1145
  end

  test "struct and embedded structs created", %{ fixtures: actions } do
    s = DigitalOcean.Actions.as_struct(actions)
    assert length(s.actions) == 3
    action = hd(s.actions)
    assert action.__struct__ == DigitalOcean.Actions.Action
    assert action.region == "nyc3"
  end

  test "actions as an enumeration", %{ fixtures: actions } do
    s = DigitalOcean.Actions.as_struct(actions)
    assert Enum.member?(s, 41152505)
  end
  
  test "actions as a limited iteration", %{ fixtures: actions } do
    Application.put_env(:digital_ocean, :use_api_paging, false)
    s = DigitalOcean.Actions.as_struct(actions)
    res = for _ <- s, do: :ok
    assert res == List.duplicate(:ok, length(s[:actions]))
    assert res == List.duplicate(:ok, Enum.count(s))

    Application.put_env(:digital_ocean, :use_api_paging, true)
    refute res == Enum.count(s) == length(s[:actions])
  end

  @tag :external
  test "retrieve and process actions, no paging" do
    Application.put_env(:digital_ocean, :use_api_paging, false)
    Application.put_env(:digital_ocean, :actions_per_page, 101)
    s = DigitalOcean.actions
    assert Enum.count(s) == 101
    a = hd(s.actions)
    assert a.__struct__ == DigitalOcean.Actions.Action
  end

  @tag :external
  test "retrieve and process actions, with paging" do
    Application.put_env(:digital_ocean, :use_api_paging, true)
    Application.put_env(:digital_ocean, :actions_per_page, 200)
    s = DigitalOcean.actions
    assert Enum.count(s) == s.meta.total
    a = hd(s.actions)
    assert a.__struct__ == DigitalOcean.Actions.Action

    res = for _ <- s, do: :ok
    assert length(res) == s.meta.total
  end

  @tag :external
  test "retrieve a single valid action" do
    Application.put_env(:digital_ocean, :use_api_paging, false)
    id = hd(DigitalOcean.actions(1).actions)[:id]
    assert {:ok, res} = DigitalOcean.action(id)
    assert res[:id] == id
    assert ^res = DigitalOcean.action!(id)
  end

  @tag :external
  test "retrieve a single invalid action" do
    assert {:error, _} = DigitalOcean.action(1)
    assert_raise DigitalOceanError, fn -> DigitalOcean.action!(1) end
  end

end
