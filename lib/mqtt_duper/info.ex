defmodule MqttDuper.Info do
  @moduledoc """
  This module implements a few functions to check the configuration of an emqtt endpoint.

  This module tends to fail without giving clear errors, and this is a first line to catch some errors.
  """

  # @spec check_mqtt_config() :: :ok
  def check_mqtt_config do
    check_mqtt_config(Application.get_env(:data_api, :emqtt))
  end

  def check_mqtt_config(nil) do
    raise "no mqtt config provided"
  end

  def check_mqtt_config(emqtt_config) do
    emqtt_config
    |> Keyword.get(:ssl_opts, nil)
    |> check_ssl_opts()
  end

  defp check_ssl_opts(nil), do: :ok

  defp check_ssl_opts(opts) do
    expected_opts = [:cacertfile, :certfile, :keyfile]

    for opt <- expected_opts do
      value = Keyword.get(opts, opt, nil)

      unless value != nil do
        raise "ssl_opts was specified in the mqtt config, but #{opt} was not set"
      end

      check_file_exists_and_readable(value)
      :ok
    end

    :ok
  end

  #############################################################################
  # helpers

  defp check_file_exists_and_readable(path) do
    unless File.exists?(path) do
      raise "file #{path} in the mqtt config does not exist"
    end

    case File.read(path) do
      {:ok, _} ->
        :ok

      _ ->
        raise "file #{path} in the mqtt config is not readable"
    end
  end
end
