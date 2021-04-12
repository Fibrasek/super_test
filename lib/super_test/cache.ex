defmodule SuperTest.Cache do
  @moduledoc false

  defmodule Manager do
    @moduledoc false

    use Supervisor

    require Logger

    def start_link(args) do
      Supervisor.start_link(__MODULE__, args, name: __MODULE__)
    end

    @impl true
    def init(_args) do
      children = [
        SuperTest.Cache.Requests,
        SuperTest.Cache.Responses
      ]

      Logger.debug("Starting Cache Manager: requests, responses")
      Supervisor.init(children, strategy: :one_for_one)
    end
  end

  defmodule Requests do
    use GenServer

    require Logger

    @ets_opts [
      :set,
      :public,
      :named_table,
      write_concurrency: true,
      read_concurrency: true
    ]

    def start_link(state) do
      GenServer.start_link(__MODULE__, state, name: __MODULE__)
    end

    @impl true
    def init(_args) do
      Logger.debug("Starting Requests Cache")
      {:ok, :ets.new(:requests, @ets_opts)}
    end
  end

  defmodule Responses do
    use GenServer

    require Logger

    @ets_opts [
      :set,
      :public,
      :named_table,
      write_concurrency: true,
      read_concurrency: true
    ]

    def start_link(state) do
      GenServer.start_link(__MODULE__, state, name: __MODULE__)
    end

    @impl true
    def init(_args) do
      Logger.debug("Starting Responses Cache")
      {:ok, :ets.new(:responses, @ets_opts)}
    end
  end
end
