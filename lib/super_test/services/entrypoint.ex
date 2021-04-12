defmodule SuperTest.Services.Entrypoint do
  @moduledoc false

  use Plug.Router

  alias SuperTest.Plugs.LogRequest
  alias SuperTest.Plugs.LogResponse

  plug LogRequest
  plug LogResponse

  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, inspect(conn))
  end

  forward "/cache", to: SuperTest.Services.Cache

  match _ do
    send_resp(conn, 404, "Oops! We tried, but found nothing :(")
  end
end
