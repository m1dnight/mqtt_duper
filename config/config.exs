import Config

config :mqtt_duper, :filters,
  topics: [
    ~r/.*/
  ]

# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
