defmodule MqttDuper.Application do
  @moduledoc false

  use Application

  @impl true
  @spec start(any, any) :: {:error, any} | {:ok, pid}

  def start(_type, _args) do
    Logging.init_logging()

    children = build_source_child_specs() ++ build_destination_child_specs()

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
