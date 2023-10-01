import Config

if config_env() == :prod do
  # assert the necessary env vars
  env =
    Map.new(["MQTT_DESTINATION_HOST", "MQTT_SOURCE_HOST"], fn var ->
      key = var |> String.downcase() |> String.to_atom()

      value =
        System.get_env(var) ||
          raise """
          environment variable #{var} is missing.
          """

      {key, value}
    end)

  config :mqtt_duper, :source,
    start: false,
    host: String.to_charlist(env.mqtt_source_host),
    port: 8883,
    clientid: "mqtt_duper_source",
    clean_start: true,
    name: :emqtt_source,
    ssl: true,
    ssl_opts: [
      verify: :verify_none,
      cacertfile: "/app/certs/source/root.crt",
      certfile: "/app/certs/source/client.crt",
      keyfile: "/app/certs/source/client.key"
    ]

  config :mqtt_duper, :destination,
    start: false,
    host: String.to_charlist(env.mqtt_destination_host),
    port: 8883,
    clientid: "mqtt_duper_destination",
    clean_start: true,
    name: :emqtt_destination,
    ssl: true,
    ssl_opts: [
      verify: :verify_none,
      cacertfile: "/app/certs/destination/root.crt",
      certfile: "/app/certs/destination/client.crt",
      keyfile: "/app/certs/destination/client.key"
    ]
end
