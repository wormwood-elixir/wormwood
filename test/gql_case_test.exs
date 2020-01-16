defmodule Wormwood.Test.GQLCaseTest do
  use ExUnit.Case
  use Wormwood.GQLCase

  load_gql(Wormwood.Examples.Schema, "assets/GetUsers.gql")

  test "Should execute a valid query" do
    result = query_gql()
    assert {:ok, _query_data} = result
  end
end
