defmodule SuperTest.Plugs.LogResponse do
  @moduledoc false
  @behaviour Plug

  alias Plug.Conn

  defmodule NoStorageFoundError do
    @moduledoc """
    Error raised if no ETS storage is found.
    """

    defexception message: "No ETS found."
  end

  defmodule RecordNotInsertedError do
    @moduledoc """
    Error raised if a record is not inserted in the storage.
    """

    defexception message: "Value not inserted."
  end

  @impl true
  def init(options), do: options

  @impl true
  def call(conn, _opts) do
    assert_ets_table_exists!(:responses)

    if :ets.tab2list(:responses) == [], do: insert(:responses, conn)

    Conn.register_before_send(conn, fn conn ->
      assert_ets_table_exists!(:responses)
      insert(:responses, conn)

      conn
    end)
  end

  defp insert(table, %Plug.Conn{host: host, method: method, request_path: path} = data) do
    value = %{
      timestamp: DateTime.utc_now(),
      host: host,
      method: method,
      path: path
    }

    :ets.insert(table, {:erlang.phash2(data), value})
  end

  defp assert_ets_table_exists!(table), do: if :ets.whereis(table) == :undefine, do: raise(NoStorageFoundError)
end
