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
   
end
