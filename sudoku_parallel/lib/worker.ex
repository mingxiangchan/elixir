defmodule SudokuParallel.Worker do
  def loop do
    receive do
      {sender_pid, board, zero_index} ->
        send(sender_pid, get_potential_solutions(board, zero_index))
      _ -> 
        IO.puts "Something went wrong!"
    end
    # loop until we receive a message to do work with!
    loop
  end

  def get_potential_solutions(board, zero_index) do
    IO.inspect self
    IO.puts "is processing #{zero_index}"
  end
end
