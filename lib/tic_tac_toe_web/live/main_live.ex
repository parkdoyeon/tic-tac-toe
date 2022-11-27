defmodule TicTacToeWeb.MainLive do
  use Phoenix.LiveView

  @topic "main"

  def mount(param, session, socket) do
    user_name = MnemonicSlugs.generate_slug(2)
    if connected?(socket) do
      TicTacToeWeb.Endpoint.subscribe(@topic)
      TicTacToeWeb.Presence.track(self(), @topic, user_name, %{})
    end

    {:ok, assign(socket, users: [], user_name: user_name, waiting_game_room: nil)}
  end

  def handle_event("start_game", _message, %{assigns: %{waiting_game_room: nil, user_name: user_name}} = socket) do
    game_room = MnemonicSlugs.generate_slug(3)
    TicTacToeWeb.Endpoint.broadcast(@topic, "room_created", %{game_room: game_room})
    {:noreply, push_redirect(socket, to: "/" <> game_room <> "?user_name=" <> user_name)}
  end

  def handle_event("start_game", _message, %{assigns: %{waiting_game_room: game_room, user_name: user_name}} = socket) do
    TicTacToeWeb.Endpoint.broadcast(@topic, "room_closed", %{})
    {:noreply, push_redirect(socket, to: "/" <> game_room <> "?user_name=" <> user_name)}
  end

  def handle_info(%{event: "room_created", payload: %{game_room: game_room}}, socket) do
    {:noreply, assign(socket, waiting_game_room: game_room)}
  end

  def handle_info(%{event: "room_closed"}, socket) do
    {:noreply, assign(socket, waiting_game_room: nil)}
  end

  def handle_info(%{event: "presence_diff"}, socket) do
    users = TicTacToeWeb.Presence.list("main")
      |> Map.keys()

    {:noreply, assign(socket, users: users)}
  end
end
