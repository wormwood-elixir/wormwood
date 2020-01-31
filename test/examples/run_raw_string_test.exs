defmodule Wormwood.Test.Examples.RunRawString do
  use ExUnit.Case
  use Wormwood.GQLCase

  @static_string """
  #import "assets/UserFields.frag.gql"

  query {
    Users {
      ...UserFields
    }
  }
  """

  set_gql(Wormwood.Examples.Schema, @static_string)

  describe "raw string" do
    test "Should return a list of all the users (all 5 of them)" do
      result = query_gql()
      assert {:ok, query_data} = result

      users = get_in(query_data, [:data, "Users"])
      assert length(users) == 5
    end
  end
end
