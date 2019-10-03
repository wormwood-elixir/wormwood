defmodule Wormwood.Test.GQLLoaderTest do
  use ExUnit.Case
  use Wormwood.GQLCase

  describe "GQL Loader" do
    test "should load a file with imports" do
      document = Wormwood.GQLLoader.load_document("assets/tests/Test.gql")
      assert String.contains?(document, "#this is just a test fragment to rest imports")
    end

    test "should raise when trying to load a non-existant file" do
      assert_raise WormwoodError, fn ->
        Wormwood.GQLLoader.load_document("assets/tests/does_not_exist.gql")
      end
    end

    test "should raise when trying to import a non-existant fragment" do
      assert_raise WormwoodError, fn ->
        Wormwood.GQLLoader.load_document("assets/tests/BadImportTest.gql")
      end
    end

    test "should raise when trying to load a file with invalid syntax" do
      assert_raise WormwoodError, fn ->
        Wormwood.GQLLoader.load_document("assets/tests/InvalidSyntaxTest.gql")
      end
    end
  end
end
