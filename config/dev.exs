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
    cacertfile: "/Users/christophe/SynologyDrive/certs/production.loomy.be/root.crt",
    certfile: "/Users/christophe/SynologyDrive/certs/production.loomy.be/data-api.crt",
    keyfile: "/Users/christophe/SynologyDrive/certs/production.loomy.be/data-api.key"
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
    cacertfile: "/Users/christophe/SynologyDrive/certs/development.loomy.be/root.crt",
    certfile: "/Users/christophe/SynologyDrive/certs/development.loomy.be/data-api.crt",
    keyfile: "/Users/christophe/SynologyDrive/certs/development.loomy.be/data-api.key"
  ]
