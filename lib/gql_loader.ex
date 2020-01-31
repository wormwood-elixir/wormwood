defmodule Wormwood.GQLLoader do
  @import_regex ~r"#import \"(.*)\""

  @doc """
  When provided a path to a GQL document, expands all import statements and attempts to parses it with Absinthe.

  Returns the query string source with imports appended.

  For example:
  ```elixir
  load_file!("assets/js/MyQuery.gql")
  ```
  """
  @spec load_file!(binary) :: binary
  def load_file!(document_path) when is_binary(document_path) do
    try_load_file(document_path)
    |> graphql_expand_imports(document_path)
    |> try_parse_document(document_path)
  end

  @doc """
  When provided the source code of a GQL document, expands all import statements and attempts to parses it with Absinthe.

  Returns the query string source with imports appended.

  For example:
  ```elixir
  load_string!(@my_query_source)
  ```
  """
  @spec load_string!(binary) :: binary
  def load_string!(query_string) when is_binary(query_string) do
    graphql_expand_imports(query_string, File.cwd!())
  end

  defp graphql_expand_imports(content, file_path) do
    Path.expand(file_path)
    |> File.dir?()
    |> case do
      false ->
        base_dir = Path.dirname(file_path)
        do_import_expansion(content, base_dir, file_path)

      true ->
        do_import_expansion(content, file_path, file_path)
    end
  end

  defp do_import_expansion(content, base_dir, file_path) do
    matches = Regex.scan(@import_regex, content)
    graphql_inject_import_matches(content, matches, base_dir, file_path)
  end

  defp graphql_inject_import_matches(content, matches, dir, parent_file) do
    case matches do
      [] ->
        content

      _ ->
        [_, import_path] = List.first(matches)

        content_to_inject =
          Path.join(dir, import_path)
          |> Path.expand()
          |> try_import_file(parent_file)
          |> graphql_expand_imports(import_path)

        (content <> content_to_inject)
        |> graphql_inject_import_matches(tl(matches), dir, parent_file)
    end
  end

  defp try_import_file(import_path, parent_file) do
    try do
      try_load_file(import_path)
    rescue
      _e in WormwoodLoaderError ->
        raise WormwoodImportError, path: import_path, parent: parent_file
    end
  end

  defp try_load_file(path) do
    File.read(path)
    |> case do
      {:ok, file_content} ->
        file_content

      {:error, reason} ->
        raise WormwoodLoaderError, path: path, reason: reason
    end
  end

  defp try_parse_document(document, src_path) do
    case Absinthe.Phase.Parse.run(%Absinthe.Language.Source{body: document}) do
      {:ok, _blueprint} ->
        document

      {:error, blueprint} ->
        error =
          blueprint.execution.validation_errors
          |> List.first()

        error_location =
          error.locations
          |> List.first()
          |> Map.get(:line)

        raise WormwoodParseError, path: src_path, err: error.message, line: error_location
    end
  end
end
