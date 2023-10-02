defmodule MqttDuper.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  @spec start(any, any) :: {:error, any} | {:ok, pid}

  def start(_type, _args) do
    debug_info()

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

  defp debug_info do
    root_dir = :code.root_dir()
    config_path = Path.join(:code.root_dir(), "/mqtt_endpoints.exs")
    config_exists? = File.exists?(config_path)

    IO.puts("""
    Root directory: #{root_dir}
    Config file: #{if config_exists?, do: File.read!(config_path), else: "#{config_path} not found"}
    """)

    # source certs
    source = Application.get_env(:mqtt_duper, :source)

    source
    |> Keyword.get(:ssl_opts, [])
    |> Keyword.get(:cacertfile, "not defined")
    |> tap(&IO.puts("source cacertfile: #{&1}"))
    |> tap(fn file -> file |> File.read!() |> IO.puts() end)

    source
    |> Keyword.get(:ssl_opts, [])
    |> Keyword.get(:certfile, "not defined")
    |> tap(&IO.puts("source certfile: #{&1}"))
    |> tap(fn file -> file |> File.read!() |> IO.puts() end)

    source
    |> Keyword.get(:ssl_opts, [])
    |> Keyword.get(:keyfile, "not defined")
    |> tap(&IO.puts("source keyfile: #{&1}"))
    |> tap(fn file -> file |> File.read!() |> IO.puts() end)

    # destination certs
    destination = Application.get_env(:mqtt_duper, :source)

    destination
    |> Keyword.get(:ssl_opts, [])
    |> Keyword.get(:cacertfile, "not defined")
    |> tap(&IO.puts("destination cacertfile: #{&1}"))
    |> tap(fn file -> file |> File.read!() |> IO.puts() end)

    destination
    |> Keyword.get(:ssl_opts, [])
    |> Keyword.get(:certfile, "not defined")
    |> tap(&IO.puts("destination certfile: #{&1}"))
    |> tap(fn file -> file |> File.read!() |> IO.puts() end)

    destination
    |> Keyword.get(:ssl_opts, [])
    |> Keyword.get(:keyfile, "not defined")
    |> tap(&IO.puts("destination keyfile: #{&1}"))
    |> tap(fn file -> file |> File.read!() |> IO.puts() end)
  end
end
