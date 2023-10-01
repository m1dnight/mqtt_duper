defmodule MqttDuper.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    children = [
      {MqttDuper.Listener,
       [
         name: :source,
         config: Application.get_env(:mqtt_duper, :source),
         handler: MqttDuper.SourceHandler
       ]},
      {MqttDuper.Listener, [name: :destination, config: Application.get_env(:mqtt_duper, :destination), handler: nil]}
    ]

    # ignore the emqtt log messages
    blocked_names = [:emqtt_source, :emqtt_destination]

    :logger.add_primary_filter(
      :emqtt_filter,
      {&MqttDuper.LogFilter.filter/2, %{blocked_names: blocked_names}}
    )

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_all, name: MqttDuper.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
