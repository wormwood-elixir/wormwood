defmodule Wormwood.Examples.ResolverHelpers do
  @moduledoc false
  alias Wormwood.Examples.StaticData

  def messages_mapped_to_user do
    Enum.map(StaticData.messages, fn msg ->
      Map.put(msg, :from, get_user_by_id(msg.from))
    end)
  end

  def find_user(_parent, %{id: id}, _) do
    {:ok, get_user_by_id(id)}
  end

  def find_user(_parent, %{email: email}, _) do
    {:ok, get_user_by_email(email)}
  end

  defp get_user_by_email(email) do
    Enum.find(StaticData.users, fn user ->
      user.email == email
    end)
  end

  defp get_user_by_id(id) when is_binary(id) do
    {real_id, _} = Integer.parse(id)
    get_user_by_id(real_id)
  end

  defp get_user_by_id(id) do
    Enum.find(StaticData.users, fn user ->
      user.id == id
    end)
  end
end
