defmodule LogisticsOcr.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LogisticsOcrWeb.Telemetry,
      LogisticsOcr.Repo,
      {DNSCluster, query: Application.get_env(:logistics_ocr, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LogisticsOcr.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: LogisticsOcr.Finch},
      # Start a worker by calling: LogisticsOcr.Worker.start_link(arg)
      # {LogisticsOcr.Worker, arg},
      # Start to serve requests, typically the last entry
      LogisticsOcrWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LogisticsOcr.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LogisticsOcrWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
