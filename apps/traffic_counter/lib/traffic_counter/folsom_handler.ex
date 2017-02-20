
defmodule TrafficCounter.FolsomHandler do
  @behaviour TrafficCounter.Handler

  require Logger

  def handle_stat(source_ip, target_host) do
    case :folsom_metrics.notify({source_ip, target_host}, {:inc, 1}) do
      {:error, _, :nonexistent_metric} ->
        :folsom_metrics.new_counter({source_ip, target_host})
        handle_stat(source_ip, target_host)
      {:error, id, code} -> Logger.error "Can not create metric for #{id}: #{code}"
      :ok -> :ok
    end
  end

end
