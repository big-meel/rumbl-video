defmodule RumblWeb.VideoChannel do
  use RumblWeb, :channel

  alias Rumbl.{Accounts, Multimedia}

  def join("videos:" <> video_id, _params, socket) do
    {:ok, assign(socket, :video_id, String.to_integer(video_id))}
  end

  # def handle_info(:ping, socket) do
  #   count = socket.assigns[:count] || 1
  #   push(socket, "ping", %{count: count})

  #   {:noreply, assign(socket, :count, count + 1)}
  # end

  def handle_in("new_annotation", params, socket) do
    case Multimedia.annotate_video(user, socket.assigns.video_id, params) do
      {:ok, annotation} ->
        broadcast!(socket, "new_annotation", %{
          id:   annotation.id,
          user: RumblWeb.UserView.render("user.json", %{user: user}),
          body: annotation.body,
          at: annotation.at
        })
        {:reply, :ok, socket}

      {:error, changeset} ->
        {:reply, {error: {:errors: changeset}}, socket}
    end
  end
end
