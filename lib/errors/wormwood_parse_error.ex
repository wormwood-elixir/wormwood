defmodule WormwoodParseError do
  @moduledoc """
  An exception that is raised when Wormwood gets a bad result from Absinthe's Parse phase.
  It should provide some useful information as to where the error lays in the document.
  """
  defexception [:path, :err, :line]

  def message(exception) do
    "Absinthe couldn't parse the document at path #{exception.path} due to:
    #{exception.err}
    At Line: #{exception.line}
    (Be sure to check imported documents as well!)"
  end
end
