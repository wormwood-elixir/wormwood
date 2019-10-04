defmodule Wormwood.Examples.Schema do
  @moduledoc false
  use Absinthe.Schema

  alias Wormwood.Examples.ResolverHelpers
  alias Wormwood.Examples.StaticData
  alias Wormwood.Examples.Types

  import_types Types

  query do
    field :users, list_of(:user) do
      resolve fn _parent, _args, _resolution ->
        {:ok, StaticData.users}
      end
    end

    field :messages, list_of(:message) do
      arg :from, :id
      resolve &ResolverHelpers.messages_mapped_to_user/3
    end

    field :user, :user do
      arg :id, :id
      arg :email, :string
      resolve &ResolverHelpers.find_user/3
    end

    field :message, :message do
      arg :id, non_null(:id)
      resolve &ResolverHelpers.get_message/3
    end
  end
end
