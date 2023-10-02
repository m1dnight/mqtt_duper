import Config

config :mqtt_duper, :filters,
  topics: [
    ~r/.*/
  ]

  config :mqtt_duper, :source,
  start: false,
  host: ~c"mqtt.production.loomy.be",
  port: 8883,
  clientid: "mqtt_duper_source",
  clean_start: true,
  name: :emqtt_source,
  ssl: true,
  ssl_opts: [
    verify: :verify_none,
    cacertfile: "/certs/source/root.crt",
    certfile:   "/certs/source/data-api.crt",
    keyfile:    "/certs/source/data-api.key"
  ]

config :mqtt_duper, :destination,
  start: false,
  host: ~c"mqtt.development.loomy.be",
  port: 8883,
  clientid: "mqtt_duper_destination",
  clean_start: true,
  name: :emqtt_destination,
  ssl: true,
  ssl_opts: [
    verify: :verify_none,
    cacertfile: "/certs/destination/root.crt",
    certfile: "/certs/destination/data-api.crt",
    keyfile: "/certs/destination/data-api.key"
  ]
