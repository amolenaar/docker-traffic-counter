defmodule ContainerNameResolver do
  @moduledoc """
  Consult docker and determine how IP addresses map to containers.

  For containers we use the full name: `org/container:tag`. I doubt that's
  the way we want it, but it's a start.

  """

  def map_name_to_ip_address() do
    query_running_containers()
    |> Enum.map(&get_ip_address_and_image_name/1)
    |> Enum.reduce(%{},
          fn([ip, n], acc) -> Map.put(acc, to_ip_address(ip), n)
            (_, acc) -> acc
          end)
  end

  defp query_running_containers() do
    cmd!("docker", ["ps", "-q"])
    |> String.split("\n", trim: true)
  end

  defp get_ip_address_and_image_name(container_id) do
    cmd!("docker", ["inspect", "--format", "{{ .NetworkSettings.IPAddress }} {{ .Config.Image }}", container_id])
    |> String.split(" ", trim: true)
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
    String.split(str, ".") |> Enum.map(&String.to_integer/1)|> List.to_tuple()
  end

end
