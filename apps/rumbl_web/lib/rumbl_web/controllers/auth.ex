defmodule RumblWeb.Auth do
  import Plug.Conn
  import Phoenix.Controller

  alias RumblWeb.Router.Helpers, as: Routes
  alias Phoenix.Token

  def init(opts), do: opts

  # Plugs receive connections and return them
  # def call(conn, _opts) do
  #   user_id = get_session(conn, :user_id)
  #   user = user_id && Rumbl.Accounts.get_user(user_id)
  #   assign(conn, :current_user, user) # Return connection with :current_user atom assigned to the user
  # end

  def login(conn, user) do
    conn
    |> put_current_user(user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end

  # NOTE: Current implementation is to make code more testable
  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    cond do
      user = conn.assigns[:current_user] ->
        put_current_user(conn, user)

      user = user_id && Rumbl.Accounts.get_user(user_id) ->
        put_current_user(conn, user)

      true ->
        assign(conn, :current_user, nil)
    end
  end

  defp put_current_user(conn, user) do
    token = Token.sign(conn, "user socket", user.id)

    conn
    |> assign(:current_user, user)
    |> assign(:user_token, token)
  end
end
