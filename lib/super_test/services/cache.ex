defmodule SuperTest.Services.Cache do
  @moduledoc false

  use Plug.Router

  plug Plug.Parsers, parsers: [:json], json_decoder: Poison

  plug :match
  plug :dispatch

  get "/" do
    with requests <- :ets.tab2list(:requests),
         responses <- :ets.tab2list(:responses) do
      data =%{
        count: %{
          requests: Enum.count(requests),
          responses: Enum.count(responses)
        },
        requests: Enum.map(requests, fn item -> elem(item, 1) end),
        responses: Enum.map(responses, fn item -> elem(item, 1) end)
      }
      render_json(conn, data)
    else
      :error -> send_resp(conn, 500, "Something went wrong cuz server is bad >:(")
      _ -> send_resp(conn, 500, "Something went wrong and don't know what happened...")
    end
  end

  match _ do
    send_resp(conn, 404, "Oops! We tried, but found nothing :(")
  end

  defp render_json(%{status: status} = conn, data) do
    send_resp(conn, (status || 200), Poison.encode!(data))
  end
end
