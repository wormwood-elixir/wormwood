defmodule Wormwood.Test.MultipleGQLCaseBadTest do
  use ExUnit.Case
  use Wormwood.GQLCase

  test "Should raise when no document is registered to the module" do
    assert_raise WormwoodSetupError, fn ->
      query_gql_by(:get_users)
    end
  end
end
