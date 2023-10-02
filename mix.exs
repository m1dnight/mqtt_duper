defmodule MqttDuper.MixProject do
  use Mix.Project

  def project do
    [
      app: :mqtt_duper,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        prod: [
          config_providers: [
            {Config.Reader, {:system, "RELEASE_ROOT", "/mqtt_endpoints.exs"}}
          ]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :ssl],
      mod: {MqttDuper.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:emqtt, github: "emqx/emqtt", tag: "1.4.4", system_env: [{"BUILD_WITHOUT_QUIC", "1"}]},
      {:styler, "~> 0.9", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.3", only: [:dev], runtime: false}
    ]
  end
end
