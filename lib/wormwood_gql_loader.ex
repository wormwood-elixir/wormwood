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
    graphql_inject_import_matches(content, matches, base_dir)
  end

  @spec graphql_inject_import_matches(binary, [List.t()], binary) :: binary
  defp graphql_inject_import_matches(content, matches, dir) do
    case matches do
      [] ->
        content
      _ ->
        [_, import_path] = List.first(matches)
        content_to_inject = Path.join(dir, import_path)
          |> Path.expand()
          |> try_load_file()

        content <> content_to_inject
          |> graphql_inject_import_matches(tl(matches), dir)
    end
  end

  defp try_load_file(path) when is_binary(path) do
    File.read(path)
      |> case do
        {:ok, file_content} ->
          file_content
        {:error, reason} ->
          raise WormwoodError, "Wormwood failed to load the file at path: '#{path}' due to: <#{reason}>"
      end
  end
end
