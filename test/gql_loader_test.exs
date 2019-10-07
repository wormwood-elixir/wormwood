defmodule Wormwood.Test.GQLLoaderTest do
  use ExUnit.Case
  use Wormwood.GQLCase

  describe "GQL Loader" do
    test "should load a file with imports" do
      document = Wormwood.GQLLoader.load_file!("assets/tests/Test.gql")
      assert String.contains?(document, "#this is just a test fragment to test imports")
    end

    test "should raise WormwoodLoaderError when trying to load a non-existent file" do
      assert_raise WormwoodLoaderError, fn ->
        Wormwood.GQLLoader.load_file!("assets/tests/does_not_exist.gql")
      end
    end

    test "should raise WormwoodImportError when trying to import a non-existent document" do
      assert_raise WormwoodImportError, fn ->
        Wormwood.GQLLoader.load_file!("assets/tests/BadImportTest.gql")
      end
    end

    test "should raise when trying to load a file with invalid syntax" do
      assert_raise WormwoodParseError, fn ->
        Wormwood.GQLLoader.load_file!("assets/tests/InvalidSyntaxTest.gql")
      end
    end

    test "should load a string as a valid query, including an import" do
      string = """
      #import "assets/tests/Test.frag.gql"
      {
        Messages {
          ...MessageFields
        }
      }
      """

      document = Wormwood.GQLLoader.load_string!(string)
      assert String.contains?(document, "#this is just a test fragment to test imports")
    end
  end
end
