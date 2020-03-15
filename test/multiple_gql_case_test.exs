defmodule Wormwood.Test.MultipleGQLCaseTest do
  use ExUnit.Case
  use Wormwood.GQLCase

  load_gql(:get_users, Wormwood.Examples.Schema, "assets/GetUsers.gql")
  load_gql(:get_messages, Wormwood.Examples.Schema, "assets/GetMessages.gql")

  test "Should execute a valid query of get_users" do
    result = query_gql_by(:get_users)
    assert {:ok, _query_data} = result
  end

  test "Should execute a valid query of get_messages" do
    result = query_gql_by(:get_messages)
    assert {:ok, _query_data} = result
  end
end
