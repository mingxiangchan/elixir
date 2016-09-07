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
    coordinator_pid = spawn(SudokuParallel.Coordinator, :loop, [self, [], tuple_size(zero_indexes)])

    zero_indexes
      |> Tuple.to_list
      |> Enum.each(fn zero_index ->
        worker_pid = spawn(SudokuParallel.Worker, :loop, [])
        send worker_pid, {coordinator_pid, board, zero_index}
      end)
    IEx.pry
  end
end
