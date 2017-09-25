defmodule Discuss.CommentsChannel do
  use Discuss.Web, :channel

  alias Discuss.{Topic, Comment}

  def join("comments:" <> topic_id, _params, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Topic
      |> Repo.get(topic_id)
      # Todo: Get the comments

    {:ok, %{comments: ["Hi there!", "Boop!"]}, assign(socket, :topic, topic)}
  end

  def handle_in(_name, %{"content" => content}, socket) do
    topic = socket.assigns.topic

    changeset = topic
      |> build_assoc(:comments)
      |> Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, _comment} ->
        # Todo: Make this work properly
        {:reply, :ok, socket}
      {:error, _comment} ->
        {:reply, :error, socket}
    end
  end
end
