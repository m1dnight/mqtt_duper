defmodule MqttDuper.Application do
  @moduledoc false

  use Application

  @blocked_names Application.compile_env(:mqtt_duper, :filtered_log_names, [])

  @impl true
  @spec start(any, any) :: {:error, any} | {:ok, pid}

  def start(_type, _args) do
    children = build_source_child_specs() ++ build_destination_child_specs()

    # ignore the emqtt log messages
    :logger.add_primary_filter(
      :emqtt_filter,
      {&MqttDuper.LogFilter.filter/2, %{blocked_names: @blocked_names}}
    )

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_all, name: MqttDuper.Supervisor]
    Supervisor.start_link(children, opts)
  end

  #############################################################################
  # Helpers

  defp build_source_child_specs do
    :mqtt_duper
    |> Application.get_env(:sources)
    |> Enum.map(fn %{name: name, config: config} ->
      {MqttDuper.Listener,
       [
         name: name,
         config: config,
         handler: MqttDuper.SourceHandler
       ]}
    end)
  end

  defp build_destination_child_specs do
    :mqtt_duper
    |> Application.get_env(:destinations)
    |> Enum.map(fn %{name: name, config: config} ->
      {MqttDuper.Listener,
       [
         name: name,
         config: config,
         handler: nil
       ]}
    end)
  end
end
