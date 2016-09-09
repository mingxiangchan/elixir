require IEx

defmodule SudokuParallel.Coordinator do
  def loop(root_pid, results \\ [], results_expected) do
    receive do
      {:ok, result} ->
        # add results to list of results
        # e.g. %{ %{1=>[], 2=> []} | 1=>[2,3,5]}
        new_results = Map.merge(results, result)
        # check if all zeros are solved
        any_pending = !(Map.values(new_results) |> Enum.any?(&(&1 == [])))
        if  any_pending do
          IO.puts "finished!"
          send self, :exit
        end
        # rerun to wait for results
        loop(root_pid, new_results, results_expected)
      :exit ->
        # send accumalated results from all workers to root process
        send(root_pid, {:ok, results}) 
    end
    # infinite loop to be run
    loop(root_pid, results, results_expected)
  end
end
