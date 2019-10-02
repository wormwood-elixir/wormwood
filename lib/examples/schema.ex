defmodule Wormwood.Examples.Schema do
  use Absinthe.Schema

  alias Wormwood.Examples.StaticData
  alias Wormwood.Examples.Types

  import_types Types

  query do
    field :users, list_of(:user) do
      resolve fn _parent, _args, _resolution ->
        {:ok, StaticData.users}
      end
    end
  end
end
