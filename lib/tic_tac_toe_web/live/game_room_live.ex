defmodule TicTacToeWeb.GameRoomLive do
  use Phoenix.LiveView

  def mount(%{"user_name" => user_name, "id" => id} = p, session, socket) do
    if connected?(socket) do
      topic = id
      TicTacToeWeb.Endpoint.subscribe(topic)
      TicTacToeWeb.Presence.track(self(), topic, user_name, %{})
    end

    {:ok, assign(socket, users: [], user_name: user_name, room_id: id)}
  end

  def handle_info(%{event: "presence_diff", topic: topic}, socket) do
    users = TicTacToeWeb.Presence.list(topic)
      |> Map.keys()

    {:noreply, assign(socket, users: users)}
  end
end
