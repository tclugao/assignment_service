defmodule AssignmentService.Schema do
  use Ecto.Schema

  schema "patient" do
    field :patient_id, :string
    field :careproviders, {:array, :string}
  end
end
