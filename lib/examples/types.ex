defmodule Wormwood.Examples.Types do
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :name, :string
    field :email, :string
  end

  object :message do
    field :id, :id
    field :from, :user
    field :message, :string
  end
end
