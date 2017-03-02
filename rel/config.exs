# Import all plugins from `rel/plugins`
# They can then be used by adding `plugin MyPlugin` to
# either an environment, or release definition, where
# `MyPlugin` is the name of the plugin module.
Path.join(["rel", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    # This sets the default release built by `mix release`
    default_release: :default,
    # This sets the default environment used by `mix release`
    default_environment: Mix.env()

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html


# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"dG)!/NFq}b.9`BmuSy%P.0kbrime[18KGHCXt).=?M<9qfXHg2T:%cA*/.^t_i_M"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"O[(UMS~((Q8];EdO[?qNX)gx_X}~>G1&X]^GIIfvhw}gQU*vIC=0`1I?&IB8`f1v"
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :docker_traffic_counter do
#  set version: "0.1.0"
  set applications: [
    traffic_counter: :permanent,
    web: :permanent
  ]
end

