defmodule WormwoodLoaderError do
  @moduledoc """
  An exception that is raised when Wormwood can't find or access a file
  """
  defexception [:path, :reason]

  def message(exception) do
    "Wormwood failed to load the document at path: '#{exception.path}' due to: <#{exception.reason}>"
  end
end
