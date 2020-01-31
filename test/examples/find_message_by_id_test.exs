defmodule Wormwood.Test.Examples.FindMessageByIDTest do
  use ExUnit.Case
  use Wormwood.GQLCase

  load_gql(Wormwood.Examples.Schema, "assets/FindMessageByID.gql")

  describe "FindMessageByID.gql" do
    test "Should return message with ID 5" do
      result = query_gql(variables: %{"id" => 5})
      assert {:ok, query_data} = result

      found_id = get_in(query_data, [:data, "message", "id"])
      assert found_id == "5"
    end

    test "Should return nil for a non-existent message" do
      result = query_gql(variables: %{"id" => 100})
      assert {:ok, %{data: %{"message" => nil}}} = result
    end
  end
end
