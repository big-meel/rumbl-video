defmodule InfoSys.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Supervisor.child_spec({InfoSys.Counter, 15}, id: :long), # new counter worker { Module, initial_value} initial_value is received by start_link
      # Supervisor.child_spec({InfoSys.Counter, 5}, id: :short), # new counter worker { Module, initial_value} initial_value is received by start_link
      # Supervisor.child_spec({InfoSys.Counter, 10}, id: :medium), # new counter worker { Module, initial_value} initial_value is received by start_link
      InfoSys.Cache,
      {Task.Supervisor, name: InfoSys.TaskSupervisor}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: InfoSys.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
