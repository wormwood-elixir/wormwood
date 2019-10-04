defmodule Wormwood.Examples.ResolverHelpers do
  @moduledoc false
  alias Wormwood.Examples.StaticData

  def messages_mapped_to_user(_, %{from: id}, _) do
    messages = StaticData.messages
      |> Enum.filter(fn msg -> msg.from == Integer.parse(id) end)
      |> Enum.map(fn msg -> Map.put(msg, :from, get_user_by_id(msg.from)) end)
    {:ok, messages}
  end

  def messages_mapped_to_user(_, _, _) do
    messages = StaticData.messages
      |> Enum.map(fn msg -> Map.put(msg, :from, get_user_by_id(msg.from)) end)
    {:ok, messages}
  end

  def find_user(_, %{id: id}, _) do
    {:ok, get_user_by_id(id)}
  end

  def find_user(_, %{email: email}, _) do
    {:ok, get_user_by_email(email)}
  end

  def get_message(_, %{id: id}, _) do
    StaticData.messages
    |> Enum.filter(fn msg -> msg.id == Integer.parse(id) end)
  end

  #####

  defp get_messages_from_user(id) do
    StaticData.messages
      |> Enum.filter(fn msg -> msg.from == id end)
  end

  defp get_user_by_email(email) do
    user = Enum.find(StaticData.users, fn user ->
      user.email == email
    end)

    case user do
      nil -> nil
      _ -> Map.put(user, :messages, get_messages_from_user(user.id))
    end
  end

  defp get_user_by_id(id) when is_binary(id) do
    {real_id, _} = Integer.parse(id)
    get_user_by_id(real_id)
  end

  defp get_user_by_id(id) do
    user = Enum.find(StaticData.users, fn user ->
      user.id == id
    end)

    case user do
      nil -> nil
      _ -> Map.put(user, :messages, get_messages_from_user(user.id))
    end
  end
end
