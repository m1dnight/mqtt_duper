defmodule Logging do
  @moduledoc false
  require Logger

  @doc """
  Initializes the logging facilities for this application.

  Installs some dynamic filters on the logger.
  """
  def init_logging do
    # ignore the emqtt log messages
    config = Application.get_env(:mqtt_duper, :logging, %{})

    :logger.add_primary_filter(
      :ignore_pid_aliases,
      {&pid_aliases_filter/2, config.ignored_pid_aliases}
    )
  end

  def warning(message) do
    Logger.warning(message)
  end

  def debug(message) do
    Logger.debug(message)
  end

  def error(message) do
    Logger.error(message)
  end

  #############################################################################
  # Dynamic filters

  # https://write.as/yuriploc/elixir-logger-and-erlang-filters
  # https://www.erlang.org/doc/man/logger#add_handler_filter-3
  defp pid_aliases_filter(%{meta: %{pid: pid}} = log_event, ignored_pid_aliases) do
    registered_name =
      pid
      |> Process.info()
      |> Keyword.get(:registered_name)

    if registered_name in ignored_pid_aliases do
      :stop
    else
      log_event
    end
  end

  defp pid_aliases_filter(log_event, _opts) do
    log_event
  end
end
