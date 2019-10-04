defmodule WormwoodImportError do
  @moduledoc """
  An exception raised by Wormwood when it cannot find a file imported via an
  `#import "some_file.gql"` statement
  """
  defexception [:path, :parent]

  def message(exception) do
    "Wormwood failed to load imported file '#{exception.path}' imported in file '#{exception.parent}'"
  end
end
