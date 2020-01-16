defmodule Wormwood.Examples.Types do
  @moduledoc false
  use Absinthe.Schema.Notation

  object :user do
    field(:id, :id)
    field(:name, :string)
    field(:email, :string)
    field(:messages, list_of(:message))
  end

  object :message do
    field(:id, :id)
    field(:from, :user)
    field(:message, :string)
  end
end
