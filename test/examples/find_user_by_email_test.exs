defmodule Wormwood.Test.Examples.FindUserByEmailTest do
  use ExUnit.Case
  use Wormwood.GQLCase

  load_gql(Wormwood.Examples.Schema, "assets/FindUserByEmail.gql")

  describe "FindUserByEmailTest.gql" do
    test "Should return the Batman user" do
      result = query_gql(variables: %{"email" => "i@ambat.man"})
      assert {:ok, query_data} = result

      user_name = get_in(query_data, [:data, "user", "name"])
      assert user_name == "Batman"
    end

    test "Should return nil for a non-existant user" do
      result = query_gql(variables: %{"email" => "not@real"})
      assert {:ok, %{data: %{"user" => nil}}} = result
    end
  end
end
