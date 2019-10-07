defmodule Wormwood.GQLCase do
  @moduledoc """
  This module defines a few helpful macros when testing against an Absinthe GraphQL schema.
  It essentially registers an Absinthe schema and a GQL document to the module they're called in.
  """

  alias Wormwood.GQLLoader

  defmacro __using__(_opts) do
    quote do
      import Wormwood.GQLCase
    end
  end

  @doc """
  Call this macro in the module you wish to load your GQL document in.

  It takes 2 arguments, the first is your Absinthe schema module, the second is a path to a GQL file that contains a GraphQL query or mutation.

  For example:
  ```elixir
  defmodule MyCoolApplication.MyModule do
    load_gql MyCoolApplication.MyAbsintheSchema, "assets/js/queries/MyQuery.gql"
    # ...
  ```
  """
  defmacro load_gql(schema, file_path) do
    quote do
      if Module.get_attribute(unquote(__CALLER__.module), :_wormwood_gql_query) != nil do
        raise WormwoodSetupError, reason: :double_declaration
      end

      document = GQLLoader.load_file(unquote(file_path))

      Module.put_attribute(unquote(__CALLER__.module), :_wormwood_gql_query, document)
      Module.put_attribute(unquote(__CALLER__.module), :_wormwood_gql_schema, unquote(schema))
    end
  end

  @doc """
  Call this macro in the module

  It takes 2 arguments, the first is your Absinthe schema module, the second is a string of a GQL query or mutation.
  This still supports imports, they will be resolved from the current working directory. (Most likely the top level of your app)

  For example:
  ```elixir
  defmodule MyCoolApplication.MyModule do
    load_gql MyCoolApplication.MyAbsintheSchema, "query { some { cool { gql { id } }}}"
    # ...
  ```
  """
  defmacro set_gql(schema, query_string) do
    quote do
      if Module.get_attribute(unquote(__CALLER__.module), :_wormwood_gql_query) != nil do
        raise WormwoodSetupError, reason: :double_declaration
      end

      document = GQLLoader.load_string(unquote(query_string))

      Module.put_attribute(unquote(__CALLER__.module), :_wormwood_gql_query, document)
      Module.put_attribute(unquote(__CALLER__.module), :_wormwood_gql_schema, unquote(schema))
    end
  end

  @doc """
  Call this macro in the module you've loaded a document into using `load_gql`

  Calling this will execute the document loaded into the module against the schema loaded in the module.
  It accepts a keyword list for `options` that are passed into [`Absinthe.run/3`](https://hexdocs.pm/absinthe/Absinthe.html#run/3).

  Please see the [Absinthe docs](https://hexdocs.pm/absinthe/Absinthe.html#run/3-options) for more information on the options that can be passed to this macro.

  Returns a tuple of the query result from the [`Absinthe.run/3`](https://hexdocs.pm/absinthe/Absinthe.html#run/3) call.

  For example:
  ```elixir
  result = query_gql(variables: %{}, context: %{})
  {:ok, query_data} = result
  ```
  """
  defmacro query_gql(options \\ []) do
    quote do
      if is_nil(@_wormwood_gql_query) do
        raise WormwoodSetupError, reason: :missing_declaration
      end

      Absinthe.run(
        @_wormwood_gql_query,
        @_wormwood_gql_schema,
        unquote(options)
      )
    end
  end
end
