defmodule GromelWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:sample", _message, socket) do
    IO.inspect "join"
    {:ok, socket}
  end

  def handle_in("new_message", %{"body" => body}, socket) do
    broadcast! socket, "new_message", %{body: body}
    {:reply, {:ok, %{body: "test"}}, socket}
  end

end
