defmodule Web.Router do
  use Plug.Router

  @moduledoc false

  if Mix.env == :dev do
    use Plug.Debugger
  end

  plug Plug.Logger
  plug Web.MetricsExporter

  plug :match
  plug :dispatch

  # catch-all
  match _ do
    send_resp(conn, 404, "Resource not found. You can find metrics at /metrics.")
  end

end
