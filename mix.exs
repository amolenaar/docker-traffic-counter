defmodule DockerTrafficCounter.Mixfile do
  use Mix.Project

  def project do
    [app: :docker_traffic_counter,
     version: "0.1.0",
     apps_path: "apps",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  defp deps do
    [{:ex_doc, "~> 0.14", only: :dev},
     {:credo, "~> 0.7.1", only: :dev, runtime: false},
     {:dialyxir, "~> 0.4", only: :dev, runtime: false}]
  end
end
