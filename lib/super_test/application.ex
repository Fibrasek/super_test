defmodule SuperTest.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SuperTest.Cache.Manager,
      {Plug.Cowboy, scheme: :http, plug: SuperTest.Services.Entrypoint, options: [port: 4000]}
    ]

    opts = [strategy: :one_for_one, name: SuperTest.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
