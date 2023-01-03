defmodule AssignmentServiceTest do
  use ExUnit.Case
  doctest AssignmentService

  test "greets the world" do
    assert AssignmentService.hello() == :world
  end
end
