require IEx

defmodule SudokuParallel do
  defmodule Board do
    defstruct cells: [], zero_indexes: {}
  end

  def solve(string) do
    cells = String.codepoints(string)
    board = %Board{cells: cells}
    processed_board = %{board | zero_indexes: find_zero_indexes(cells)}
    find_potential_solutions(processed_board)
  end

  def find_zero_indexes(cells) do
    cells 
      |> Enum.with_index
      |> Enum.filter( &(elem(&1, 0) == "0") )
      |> Enum.map( &(elem(&1, 1)) )
      |> List.to_tuple
  end

  def find_potential_solutions(%Board{cells: cells, zero_indexes: zero_indexes }) do
    board = %Board{cells: cells, zero_indexes: zero_indexes }
    potential_solutions = zero_indexes 
                            |> Tuple.to_list 
                            |> Enum.reduce(%{}, fn(x, acc) -> Map.put(acc, x, [])  end)
    coordinator_pid = spawn(SudokuParallel.Coordinator, :loop, [self,  potential_solutions, %{}])

    zero_indexes
      |> Tuple.to_list
      |> Enum.each(fn zero_index ->
        worker_pid = spawn(SudokuParallel.Worker, :loop, [])
        send worker_pid, {coordinator_pid, board, zero_index}
      end)

    wait_for_results(board)
  end

  def wait_for_results(board) do
    receive do
      {:ok, results} ->
        IEx.pry
      _ ->
        IO.puts "Something went wrong"
    end
    wait_for_results(board)
  end
end
