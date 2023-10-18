import Config

#############################################################################
# Logging Filters

config :mqtt_duper,
  logging: %{
    ignored_pid_aliases: [
      :emqtt_source,
      :emqtt_destination
    ]
  }

#############################################################################
# Mqtt Topic Filters

config :mqtt_duper, :filters, topics: []

#############################################################################
# Mqtt Topic Transformers

config :mqtt_duper, :transformers, topics: []

#############################################################################
# Mqtt Endpoints

config :mqtt_duper,
  sources: [],
  destinations: []

# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
