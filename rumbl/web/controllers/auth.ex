defmodule Rumbl.Auth do
  import Plug.Conn

  def init(opts) do
    # raises error if unable to fetch
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    user = user_id && repo.get(Rumbl.User, user_id)
    # transforms the conn, stores user in conn.assigns. this way current_user is available in all downstream functions
    assign(conn, :current_user, user)
  end
end
