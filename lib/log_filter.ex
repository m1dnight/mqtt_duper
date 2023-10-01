defmodule MqttDuper.LogFilter do
  @moduledoc false
  # https://write.as/yuriploc/elixir-logger-and-erlang-filters
  # https://www.erlang.org/doc/man/logger#add_handler_filter-3
  def filter(%{meta: %{pid: pid}} = log_event, opts) do
    blocked_pids =
      opts.blocked_names
      |> Enum.map(&Process.whereis/1)
      |> Enum.filter(& &1)

    if pid in blocked_pids do
      :stop
    else
      log_event
    end
  end

  def filter(log_event, _opts) do
    log_event
  end
end
