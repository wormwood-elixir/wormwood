defmodule Wormwood.Test.Examples.GetUsersPipelineTest do
  use ExUnit.Case
  use Wormwood.GQLCase

  load_gql(Wormwood.Examples.Schema, "assets/GetUsers.gql")

  describe "GetUsers.gql with Custom pipeline" do
    test "Should run with a custom pipeline, returning a blueprint of the query" do
      pipeline = [Absinthe.Phase.Parse, Absinthe.Phase.Blueprint]

      result = query_gql_with_pipeline(pipeline)
      assert {:ok, %Absinthe.Blueprint{} = _blueprint, _pipeline} = result
    end
  end
end
