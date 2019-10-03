defmodule Wormwood.Examples.ResolverHelpers do
  alias Wormwood.Examples.StaticData

  def get_users_messages(user_id) do
    Enum.filter(StaticData.messages, fn msg ->
      msg.id == user_id
    end)
  end

  def get_user_by_email(email) do
    Enum.find(StaticData.users, fn user ->
      user.email == email
    end)
  end
end
