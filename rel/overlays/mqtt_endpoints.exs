import Config

config :mqtt_duper, :filters,
  topics: [
    ~r/.*/
  ]

config :mqtt_duper, :source,
  start: false,
  host: ~c"endpoint.com",
  port: 8883,
  clientid: "mqtt_duper_source",
  clean_start: true,
  name: :emqtt_source,
  ssl: true,
  ssl_opts: [
    verify: :verify_none,
    cacertfile: "./certs/source/root.crt",
    certfile: "./certs/source/client.crt",
    keyfile: "./certs/source/client.key"
  ]

config :mqtt_duper, :destination,
  start: false,
  host: ~c"endpoint.localdomain",
  port: 8883,
  clientid: "mqtt_duper_destination",
  clean_start: true,
  name: :emqtt_destination,
  ssl: true,
  ssl_opts: [
    verify: :verify_none,
    cacertfile: "./certs/destination/root.crt",
    certfile: "./certs/destination/client.crt",
    keyfile: "./certs/destination/client.key"
  ]
