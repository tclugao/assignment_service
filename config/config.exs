import Config

config :assignment_service, AssignmentService.Repo,
  database: "assignment",
  username: "postgres",
  password: "postgres",
  hostname: "178.17.0.40"

config :assignment_service,
  ecto_repos: [AssignmentService.Repo]
