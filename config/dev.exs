import Config

config :mqtt_duper,
  filtered_log_names: [
    :emqtt_source,
    :emqtt_destination
  ]

config :mqtt_duper, :filters,
  topics: [
    ~r/^79CC95A3-7215-4104-A0AC-EB30BC202CD7/,
    ~r/^E3722AB1-14CB-47D0-B36F-44A2FFD87DC3/,
    ~r/^google-oauth2|101118325271199743325/
  ]

config :mqtt_duper, :transformers,
  topics: [
    {~r/^E3722AB1-14CB-47D0-B36F-44A2FFD87DC3/, "8d0cf8dd-88da-4805-9d5a-01f9487423c2"},
    {~r/^79CC95A3-7215-4104-A0AC-EB30BC202CD7/, "8475f450-5745-4885-a019-f8a9de998881"},
    {~r/^google-oauth2|101118325271199743325"/, "auth0|6517de2a7e59ace9af53dabc"}
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

# config :mqtt_duper, :source,
#   start: false,
#   host: ~c"mqtt.development.loomy.be",
#   port: 8883,
#   clientid: "mqtt_duper_source",
#   clean_start: true,
#   name: :emqtt_source,
#   ssl: true,
#   ssl_opts: [
#     verify: :verify_none,
#     cacertfile: "/Users/christophe/SynologyDrive/certs/development.loomy.be/root.crt",
#     certfile: "/Users/christophe/SynologyDrive/certs/development.loomy.be/data-api.crt",
#     keyfile: "/Users/christophe/SynologyDrive/certs/development.loomy.be/data-api.key"
#   ]

# config :mqtt_duper, :destination,
#   start: false,
#   host: ~c"mqtt.development.loomy.be",
#   port: 8883,
#   clientid: "mqtt_duper_destination",
#   clean_start: true,
#   name: :emqtt_destination,
#   ssl: true,
#   ssl_opts: [
#     verify: :verify_none,
#     cacertfile: "/Users/christophe/SynologyDrive/certs/development.loomy.be/root.crt",
#     certfile: "/Users/christophe/SynologyDrive/certs/development.loomy.be/data-api.crt",
#     keyfile: "/Users/christophe/SynologyDrive/certs/development.loomy.be/data-api.key"
#   ]

config :mqtt_duper, :destination,
  start: false,
  host: ~c"mqtt.production.loomy.be",
  port: 8883,
  clientid: "mqtt_duper_destination",
  clean_start: true,
  name: :emqtt_destination,
  ssl: true,
  ssl_opts: [
    verify: :verify_none,
    cacertfile: "/Users/christophe/SynologyDrive/certs/production.loomy.be/root.crt",
    certfile: "/Users/christophe/SynologyDrive/certs/production.loomy.be/data-api.crt",
    keyfile: "/Users/christophe/SynologyDrive/certs/production.loomy.be/data-api.key"
  ]
