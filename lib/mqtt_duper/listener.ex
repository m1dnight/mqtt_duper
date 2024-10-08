defmodule MqttDuper.Listener do
  @moduledoc false

  use GenServer

  def child_spec(name: name, config: config, handler: handler) do
    # %{id: MqttDuper.Listener, start: {MqttDuper.Listener, :start_link, [[]]}}
    %{
      id: {__MODULE__, name},
      start: {__MODULE__, :start_link, [[config: config, handler: handler]]}
    }
  end

  @spec start_link([{:config, any} | {:handler, any}, ...]) ::
          :ignore | {:error, any} | {:ok, pid}
  def start_link(config: config, handler: handler) do
    MqttDuper.Info.check_mqtt_config(config)
    GenServer.start_link(__MODULE__, config: config, handler: handler)
  end

  def init(config: config, handler: handler) do
    Logging.debug("connecting to mqtt with options: #{inspect(config)}")

    case :emqtt.start_link(config) do
      {:ok, pid} ->
        state = %{pid: pid, config: config, handler: handler}
        {:ok, state, {:continue, :start_emqtt}}

      {:error, _} ->
        {:stop, :failed_to_connect_to_mqtt}
    end
  end

  def handle_continue(:start_emqtt, %{pid: pid, config: _config} = state) do
    {:ok, _} = :emqtt.connect(pid)
    {:ok, _, _} = :emqtt.subscribe(pid, {"#", 1})

    {:noreply, state}
  end

  @doc """
  Example of an MQTT message:

  ```
  {:publish,
  %{
   client_pid: #PID<0.245.0>,
   dup: false,
   packet_id: :undefined,
   payload: "0.358",
   properties: :undefined,
   qos: 0,
   retain: false,
   topic: "topic/topic"
  }}
  ```
  """
  def handle_info(_m, %{handler: nil} = state) do
    {:noreply, state}
  end

  def handle_info(m, %{handler: handler} = state) do
    handler.handle_message(m, state)
    {:noreply, state}
  end
end
