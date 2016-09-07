defmodule SudokuParallel.Coordinator do
  def loop(root_pid, results \\ [], results_expected) do
    receive do
      {:ok, result} ->
        # add results to list of results
        new_results = [result|result]
        # check if all zeros are solved
        if results_expected == Enum.count(new_results) do
          # inform self to exit
          send self, :exit
        end
        # rerun to wait for results
        loop(root_pid, new_results, results_expected)
      :exit ->
        # send accumalated results from all workers to root process
        send(root_pid, results) 
    end
    # infinite loop to be run
    loop(root_pid, results, results_expected)
  end
end
