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
  
  
end
