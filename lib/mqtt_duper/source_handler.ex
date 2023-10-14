defmodule MqttDuper.SourceHandler do
  @moduledoc false
  require Logger

  @type state :: %{pid: pid}
  @type publish_message :: {:publish, %{topic: String.t(), payload: String.t()}}

  @spec handle_message(publish_message, state) ::
          {:ok, :forwarded} | {:ok, :ignored} | {:error, term()}
  def handle_message({:publish, %{topic: _, payload: _}} = m, _state) do
    if forward?(m) do
      m
      |> transform_topic()
      |> forward_message()

      {:ok, :forwarded}
    else
      {:ok, :ignored}
    end
  end

  def handle_message(m, _) do
    {:error, {:handle_unknown_message, m}}
  end

  #############################################################################
  # Helpers

  @spec transform_topic(publish_message) :: publish_message
  defp transform_topic(message) do
    :mqtt_duper
    |> Application.get_env(:transformers, [])
    |> Keyword.get(:topics, [])
    |> Enum.reduce(message, fn {regex, replacement}, message ->
      case message do
        {:publish, m} ->
          transformed = Map.update!(m, :topic, fn topic -> Regex.replace(regex, topic, replacement) end)
          {:publish, transformed}

        _ ->
          message
      end
    end)
  end

  @spec forward?(publish_message) :: true | false
  defp forward?(m) do
    forward_topic?(m)
  end

  @spec forward_topic?(publish_message) :: true | false
  defp forward_topic?({:publish, %{topic: topic}}) do
    :mqtt_duper
    |> Application.get_env(:filters, [])
    |> Keyword.get(:topics, [])
    |> Enum.any?(fn topic_filter -> Regex.match?(topic_filter, topic) end)
  end

  @spec forward_message(publish_message) :: :ok | {:error, term()}
  defp forward_message({:publish, %{topic: topic, payload: payload}}) do
    case Process.whereis(:emqtt_destination) do
      nil -> :ok
      pid -> :emqtt.publish(pid, topic, payload)
    end
  rescue
    e ->
      {:error, {:error_publishing_message, e}}
      :ok
  end
end
