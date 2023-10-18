defmodule MqttDuper.SourceHandler do
  @moduledoc false
  require Logger

  @type state :: %{pid: pid}
  @type publish_message :: {:publish, %{topic: String.t(), payload: String.t()}}

  @spec handle_message(publish_message, state) ::
          {:ok, :forwarded} | {:ok, :ignored} | {:error, term()}
  def handle_message({:publish, %{topic: topic, payload: payload}} = m, _state) do
    if forward?(m) do
      Logging.debug("forwarding #{topic} #{payload}")

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
  # Transforming

  # @doc """
  # Transforms the topic of the message by applying all availble transformers.
  # """
  @spec transform_topic(publish_message) :: publish_message
  defp transform_topic(message) do
    :mqtt_duper
    |> Application.get_env(:transformers, [])
    |> Keyword.get(:topics, [])
    |> Enum.reduce(message, &apply_transformer/2)
  end

  # @doc """
  # Applies a transformer to the given message.
  # """
  @spec apply_transformer({Regex.t(), String.t()}, publish_message | any) :: publish_message | any
  defp apply_transformer({regex, replacement}, {:publish, message}) do
    transformed = Map.update!(message, :topic, fn topic -> Regex.replace(regex, topic, replacement) end)
    {:publish, transformed}
  end

  defp apply_transformer(_transformer, message) do
    message
  end

  #############################################################################
  # Forwarding

  # @doc """
  # Checks if the message must be forwarded.
  # """
  @spec forward?(publish_message) :: true | false
  defp forward?(m) do
    forward_topic?(m)
  end

  # @doc """
  # Checks if the topic of the given message is eligible for forwarding.
  # """
  @spec forward_topic?(publish_message) :: true | false
  defp forward_topic?({:publish, %{topic: topic}}) do
    :mqtt_duper
    |> Application.get_env(:filters, [])
    |> Keyword.get(:topics, [])
    |> Enum.any?(fn topic_filter -> Regex.match?(topic_filter, topic) end)
  end

  # @doc """
  # Forwards the message on the MQTT endpoint.
  # """
  @spec forward_message(publish_message) :: :ok | {:error, term()}
  defp forward_message({:publish, %{topic: topic, payload: payload}}) do
    case Process.whereis(:emqtt_destination) do
      nil ->
        :ok

      pid ->
        Logging.debug("publishing #{topic} #{payload}")
        :emqtt.publish(pid, topic, payload)
    end
  rescue
    e ->
      {:error, {:error_publishing_message, e}}
      :ok
  end
end
