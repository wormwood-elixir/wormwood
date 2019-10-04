defmodule Wormwood.Test.GQLCaseBadTest do
  use ExUnit.Case
  use Wormwood.GQLCase

  test "Should raise when no document is registered to the module" do
    assert_raise WormwoodError, fn ->
      query_gql()
    end
  end
end
