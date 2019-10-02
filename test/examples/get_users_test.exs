defmodule Wormwood.Test.Examples.GetUsersTest do
  use ExUnit.Case
  use Wormwood.GQLCase

  load_gql Wormwood.Examples.Schema, "assets/GetUsers.gql"

  describe "GetUsers.gql" do
    test "Should return a list of all the users (all 5 of them)" do
      result = query_gql()
      assert {:ok, query_data} = result

      users = get_in(query_data, [:data, "Users"])
      assert length(users) == 5
    end
  end
end
