defmodule NervesHub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias NervesHub.{Socket, FirmwareChannel}

  def start(_type, _args) do
    # List all child processes to be supervised
    Application.get_env(:nerves_hub, Socket)
    |> Socket.configure()

    children = [
      Socket,
      {FirmwareChannel, [socket: Socket, topic: FirmwareChannel.topic()]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NervesHub.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
