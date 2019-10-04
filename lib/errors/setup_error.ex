defmodule WormwoodSetupError do
  @moduledoc """
  An exception that is raised when Wormwood is called improperly
  """
  defexception [:reason]

  def message(exception) do
    case exception.reason do
      :double_declaration ->
        "You cannot declare two 'load_gql' statements in the same module."
      :missing_declaration ->
        "No GQL document was registered on this module, please check the docs on using the `load_gql`"
    end
  end
end
