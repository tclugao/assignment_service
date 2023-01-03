defmodule AssignmentService.Repo do
  use Ecto.Repo,
    otp_app: :assignment_service,
    adapter: Ecto.Adapters.Postgres
end
