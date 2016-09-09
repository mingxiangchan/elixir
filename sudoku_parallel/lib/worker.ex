defmodule SudokuParallel.Worker do
  def loop do
    receive do
      {sender_pid, board, zero_index} ->
        solutions = SudokuParallel.Validation.get_potential_solutions(board, zero_index)
        send(sender_pid, {:ok, %{zero_index => solutions}})
      _ -> 
        IO.puts "Something went wrong!"
    end
    # loop until we receive a message to do work with!
    loop
  end
end
