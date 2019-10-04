defmodule Wormwood.Test.GQLCaseTest do
  use ExUnit.Case
  use Wormwood.GQLCase

  test "Should raise when no document is registered to the module" do
    assert_raise WormwoodSetupError, fn ->
      query_gql()
    end
  end
end
