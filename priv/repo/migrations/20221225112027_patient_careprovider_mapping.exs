defmodule AssignmentService.Repo.Migrations.PatientCareproviderMapping do
  use Ecto.Migration

  def change do
    create table(:patient) do
      add :patient_id, :string
      add :careproviders, {:array, :string}
    end
  end
end
