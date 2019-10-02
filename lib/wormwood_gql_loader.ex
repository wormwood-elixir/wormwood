defmodule Wormwood.GQLLoader do
  @import_regex ~r"#import \"(.*)\""

  @spec load_document(binary) :: binary
  def load_document(document_path) when is_binary(document_path) do
    try_load_file(document_path)
      |> graphql_expand_imports(document_path)
  end

  @spec graphql_expand_imports(binary, binary) :: binary
  defp graphql_expand_imports(content, file_path) do
    base_dir = Path.dirname(file_path)
    matches = Regex.scan(@import_regex, content)
    graphql_inject_import_matches(content, matches, base_dir, file_path)
  end

  defp graphql_inject_import_matches(content, matches, dir, parent_file) do
    case matches do
      [] ->
        content
      _ ->
        [_, import_path] = List.first(matches)
        content_to_inject = Path.join(dir, import_path)
          |> Path.expand()
          |> try_import_file(parent_file)

        content <> content_to_inject
          |> graphql_inject_import_matches(tl(matches), dir, parent_file)
    end
  end

  defp try_import_file(import_path, parent_file) do
    try do
      try_load_file(import_path)
    rescue
      _e in WormwoodError ->
        raise WormwoodError, "Wormwood failed to load imported file '#{import_path}' imported from file '#{parent_file}'"
    end
  end

  defp try_load_file(path) when is_binary(path) do
    File.read(path)
      |> case do
        {:ok, file_content} ->
          file_content
        {:error, reason} ->
          raise WormwoodError, "Wormwood failed to load the document at path: '#{path}' due to: <#{reason}>"
      end
  end
end
