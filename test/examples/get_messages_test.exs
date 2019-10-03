defmodule Wormwood.Test.Examples.GetMessagesTest do
  use ExUnit.Case
  use Wormwood.GQLCase

  load_gql Wormwood.Examples.Schema, "assets/GetMessages.gql"

  describe "GetMessages.gql" do
    test "Should return a list of all the messages (all 10 of them)" do
      result = query_gql()
      assert {:ok, query_data} = result

      messages = get_in(query_data, [:data, "Messages"])
      assert length(messages) == 10
    end
  end
end
