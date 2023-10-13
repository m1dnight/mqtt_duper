import Config

config :mqtt_duper,
  filtered_log_names: [
    :emqtt_source,
    :emqtt_destination
  ]

config :mqtt_duper, :filters,
  topics: [
    ~r/^allowed/
  ]

config :mqtt_duper, :transformers,
  topics: [
    {~r/from/, "to"}
  ]

# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
