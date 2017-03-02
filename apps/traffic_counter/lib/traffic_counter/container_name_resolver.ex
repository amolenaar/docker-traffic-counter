defmodule TrafficCounter.ContainerNameResolver do
  use GenServer

  @moduledoc """
  Consult docker and determine how IP addresses map to containers.

  For containers we use the full name: `org/container:tag`. I doubt that's
  the way we want it, but it's a start.

  """

  require Logger

  def start_link(name \\ __MODULE__) do
    GenServer.start_link(__MODULE__, [], [name: name])
  end

  @doc """
  Perform a lookup call. If the requested address is not in the lookup table, it's
  IP address formatted as a string and returned instead.

  `name` is optional and defaults to the module name.
  """
  def lookup(name \\ __MODULE__, ip_address) do
    GenServer.call(name, {:lookup, ip_address})
  end


  ###############
  # Server code #
  ###############

  # How to handle stale mapping? What will happen if the refresh task does not return?

  def init([]) do
    schedule_refresh()
    {:ok, map_ip_addresses_to_names()}
  end

  @doc """
  Server side of `lookup/2`.
  """
  def handle_call({:lookup, ip_address}, _from, mapping) do
    {:reply, Map.get_lazy(mapping, ip_address, fn() -> ip_address |> Tuple.to_list |> Enum.join(".") end), mapping}
  end

  @doc """
  Handle a request for a `:refresh_mapping`. A async task is spun up to do the actual
  refresh. The result is send back to this server in a `:new_mapping` message.
   """
  def handle_info(:refresh_mapping, state) do
    Logger.debug "Refreshing docker container mapping"
    my_pid = self()
    Task.start_link(fn() ->
      send my_pid, {:new_mapping, map_ip_addresses_to_names()}
    end)
    schedule_refresh()
    {:noreply, state}
  end

  @doc """
  Apply a new mapping, coming for the task started on a `:refresh_mapping` request.
  """
  def handle_info({:new_mapping, new_mapping}, _state) do
    Logger.debug "Received new container mapping #{inspect new_mapping}"
    {:noreply, new_mapping}
  end

  @doc """
  Handle any unknown info message by logging it.
  """
  def handle_info(unknown_msg, state) do
    Logger.warn("Unexpected info message: #{inspect unknown_msg}")
    {:noreply, state}
  end

  defp schedule_refresh() do
    Process.send_after(self(), :refresh_mapping, 30_000)
  end

  defp map_ip_addresses_to_names() do
    query_running_containers()
    |> Enum.map(&get_ip_address_and_image_name/1)
    |> Enum.reduce(%{},
          fn([ip, n], acc) -> Map.put(acc, to_ip_address(ip), n)
            (_, acc) -> acc
          end)
  end

  defp query_running_containers() do
    out = cmd!("docker", ["ps", "-q"])
    out |> String.split("\n", trim: true)
  end

  defp get_ip_address_and_image_name(container_id) do
    out = cmd!("docker", ["inspect", "--format", "{{ .NetworkSettings.IPAddress }} {{ .Config.Image }}", container_id])
    out |> String.split(" ", trim: true)
  end

  ##
  # Execute a command and assume it always returns with an exit code 0.
  defp cmd!(command, args) do
    {data, 0} = System.cmd(command, args)
    data |> String.trim()
  end

  ##
  # Convert a string `"127.0.0.1"` to a tuple `{127, 0, 0, 1}`.
  #
  # The tuple format is the one used internally for IP(v4) addresses.
  defp to_ip_address(str) do
    str |> String.split(".") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
  end

end
