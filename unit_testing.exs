ExUnit.configure(exclude: [pending: true])
# configure ExUnit
# skip pending tasks -> ExUnit.configure(exclude: [pending: true])
#   then append '@tag: pending' before a test
# 
ExUnit.start

defmodule UnitTest do
  use ExUnit.Case, async: true
  # async: true runs tests in parallel, defaults to false

  setup do 
    {:ok, :pid} = 25
    {:ok, [pid: pid]}
  end

  test "the truth" do
    assert 2 + 2 == 4
  end

  test "refutation" do
    refute 2 + 2 == 5
  end

  test "test setup" do 
    assert context[:pid] == 25
  end
end

# note to self
# look into ExSpec(rspec wrapper for ExUnit) and ESpec(built from scratch)
