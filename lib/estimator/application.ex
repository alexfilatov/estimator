defmodule Estimator.Application do
  @moduledoc """
  Application module
  """
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(Estimator.Repo, []),
      supervisor(Estimator.Web.Endpoint, []),
      supervisor(Estimator.Web.Presence, []),
      supervisor(Estimator.Moderator, []),
      supervisor(Estimator.Issue.CurrentIssue, []),
      supervisor(ConCache, [[ttl: :timer.seconds(3600)], [name: :jira_backlog]])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Estimator.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
