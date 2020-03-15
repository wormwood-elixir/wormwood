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
  Call this macro in the module you wish to load your GQL documents in.

  It takes 3 arguments, the first is the query_name that you want to query.

  ```elixir
   defmodule MyCoolApplication.MyModule do
    load_gql :my_query, MyCoolApplication.MyAbsintheSchema, "assets/js/queries/MyQuery.gql"
    # ...
  ```

  After you define the query name at up code, you can call the query with
  ```elixir
  result = query_gql_by(:my_query, variables: %{}, context: %{})
  {:ok, query_data} = result
  ```

  """
  defmacro load_gql(query_name, schema, file_path) when is_atom(query_name) do
    quote do
      document = GQLLoader.load_file!(unquote(file_path))
      Module.put_attribute(unquote(__CALLER__.module), :_wormwood_gql_schema, unquote(schema))
      Module.register_attribute(unquote(__CALLER__.module), unquote(query_name), persist: true)
      Module.put_attribute(unquote(__CALLER__.module), unquote(query_name), document)
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

      document = GQLLoader.load_file!(unquote(file_path))

      Module.put_attribute(unquote(__CALLER__.module), :_wormwood_gql_query, document)
      Module.put_attribute(unquote(__CALLER__.module), :_wormwood_gql_schema, unquote(schema))
    end
  end

  @doc """
  Call this macro in the module where you want to query using a static string as your query.

  It takes 2 arguments, the first is your Absinthe schema module, the second is a string of a GQL query or mutation.
  This still supports imports, they will be resolved from the current working directory. (Most likely the top level of your app)

  For example:
  ```elixir
  defmodule MyCoolApplication.MyModule do
    set_gql MyCoolApplication.MyAbsintheSchema, "query { some { cool { gql { id } }}}"
    # ...
  ```
  """
  defmacro set_gql(schema, query_string) do
    quote do
      if Module.get_attribute(unquote(__CALLER__.module), :_wormwood_gql_query) != nil do
        raise WormwoodSetupError, reason: :double_declaration
      end

      document = GQLLoader.load_string!(unquote(query_string))

      Module.put_attribute(unquote(__CALLER__.module), :_wormwood_gql_query, document)
      Module.put_attribute(unquote(__CALLER__.module), :_wormwood_gql_schema, unquote(schema))
    end
  end

  @doc """
  Call this macro in the module you've loaded a document into using `load_gql/3`.

  For example:
  ```elixir
  result = query_gql_by(:my_query, variables: %{}, context: %{})
  {:ok, query_data} = result
  ```
  """
  defmacro query_gql_by(query_name, options \\ []) do
    quote do
      attribute =
        unquote(__CALLER__.module).__info__(:attributes)[unquote(query_name)]
        |> case do
          nil -> nil
          list -> List.last(list)
        end

      if is_nil(attribute) do
        raise WormwoodSetupError, reason: :missing_declaration
      end

      Absinthe.run(
        attribute,
        @_wormwood_gql_schema,
        unquote(options)
      )
    end
  end

  @doc """
  Call this macro in the module you've loaded a document into using `load_gql` or `set_gql`.

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

  @doc """
  Call this macro in the module you've loaded a document into using `load_gql` or `set_gql`.

  Calling this will execute the document loaded into the module against the schema loaded in the module.
  Absinthe will use the phases in the "pipeline_phases" list argument when running.
  It also accepts a keyword list for `options` that are passed into [`Absinthe.run/3`](https://hexdocs.pm/absinthe/Absinthe.html#run/3).

  Please see the [Absinthe docs](https://hexdocs.pm/absinthe/Absinthe.html#run/3-options) for more information on the options that can be passed to this macro.

  Returns a tuple of the query result from the [`Absinthe.Pipeline.run/2`](https://hexdocs.pm/absinthe/Absinthe.Pipeline.html#run/2) call.

  For example:
  ```elixir
  pipeline = [Absinthe.Phase.Parse, Absinthe.Phase.Blueprint]
  result = query_gql_with_pipeline(pipeline)
  assert {:ok, %Absinthe.Blueprint{} = _blueprint, _pipeline} = result
  ```
  """
  defmacro query_gql_with_pipeline(pipeline_phases \\ [], options \\ []) do
    quote do
      if is_nil(@_wormwood_gql_query) do
        raise WormwoodSetupError, reason: :missing_declaration
      end

      options_list =
        unquote(options)
        |> Keyword.put(:schema, @_wormwood_gql_schema)
        |> Absinthe.Pipeline.options()

      pipeline = Enum.map(unquote(pipeline_phases), fn phase -> {phase, options_list} end)

      Absinthe.Pipeline.run(@_wormwood_gql_query, pipeline)
    end
  end
end
