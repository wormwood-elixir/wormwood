defmodule Wormwood.GQLCase do
  @moduledoc """
  This module defines a few helpful macros when testing
  against an Absinthe GraphQL schema.
  """

  alias Wormwood.GQLLoader

  defmacro __using__(_opts) do
    quote do
      import Wormwood.GQLCase
    end
  end

  defmacro load_gql(schema, file_path) do
    quote do
      document = GQLLoader.load_document(unquote(file_path))
      Module.put_attribute(unquote(__CALLER__.module), :_wormwood_gql_query, document)
      Module.put_attribute(unquote(__CALLER__.module), :_wormwood_gql_schema, unquote(schema))
    end
  end

  defmacro query_gql(options) do
    quote do
      Absinthe.run(
        @_wormwood_gql_query,
        @_wormwood_gql_schema,
        unquote(options)
      )
    end
  end
end
