defmodule Wormwood.Test.MultipleGQLCaseTest do
  use ExUnit.Case
  use Wormwood.GQLCase

  load_gql(:get_users_using_load, Wormwood.Examples.Schema, "assets/GetUsers.gql")
  load_gql(:get_messages_using_load, Wormwood.Examples.Schema, "assets/GetMessages.gql")

  set_gql(:get_users_using_set, Wormwood.Examples.Schema, """
  #import "assets/UserFields.frag.gql"
  query {
    Users {
      ...UserFields
    }
  }
  """)

  set_gql(:get_messages_using_set, Wormwood.Examples.Schema, """
  #import "assets/MessageFields.frag.gql"
  query {
    Messages {
      ...MessageFields
    }
  }
  """)

  test "Should execute a valid query of get_users_using_load" do
    result = query_gql_by(:get_users_using_load)
    assert {:ok, _query_data} = result
  end

  test "Should execute a valid query of get_messages_using_load" do
    result = query_gql_by(:get_messages_using_load)
    assert {:ok, _query_data} = result
  end

  test "Should execute a valid query of get_users_using_set" do
    result = query_gql_by(:get_users_using_set)
    assert {:ok, _query_data} = result
  end

  test "Should execute a valid query of get_messages_using_set" do
    result = query_gql_by(:get_messages_using_set)
    assert {:ok, _query_data} = result
  end
end
