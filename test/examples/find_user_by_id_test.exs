defmodule Wormwood.Test.Examples.FindUserByIDTest do
  use ExUnit.Case
  use Wormwood.GQLCase

  load_gql(Wormwood.Examples.Schema, "assets/FindUserByID.gql")

  describe "FindUserByID.gql" do
    test "Should return the Foilz user, and all 3 of their messages" do
      result = query_gql(variables: %{"id" => 1})
      assert {:ok, query_data} = result

      user_name = get_in(query_data, [:data, "user", "name"])
      messages = get_in(query_data, [:data, "user", "messages"])
      assert user_name == "Foilz"
      assert length(messages) == 3
    end

    test "Should return nil for a non-existant user" do
      result = query_gql(variables: %{"id" => 100})
      assert {:ok, %{data: %{"user" => nil}}} = result
    end
  end
end
