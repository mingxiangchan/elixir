require IEx
# use IEx.pry to byebug

board_string = "096040001100060004504810390007950043030080000405023018010630059059070830003590007"

defmodule Sudoku do
  @numbers String.codepoints("123456789")

  #  defmodule Board do 
  # defstruct current_board: [], zeros: %{}
  #end

  def solve(board_string) do
      board_cells = String.codepoints board_string
      zeros = find_zeros(board_cells)
      solve_board( board_cells, zeros , 0)
  end

  def find_zeros(board) do
    board
      |> Enum.with_index
      |> Enum.filter( &(elem(&1, 0) == "0") )
      |> Enum.map( &(elem(&1, 1)) )
      |> List.to_tuple
  end

  def display_board(""), do: IO.puts "Nothing to print!" 

  def  display_board(board_string) do
      row = String.split_at(board_string, 9)
      IO.puts elem(row, 0) |> String.replace("0",".")
      elem(row, 1)
        |> display_board
  end

  def solve_board(board, zeros, zero_index) when zero_index >= tuple_size(zeros) do 
    IO.puts "Solved!"
    Enum.join(board, "") |> display_board
  end

  def solve_board(board,zeros, zero_index) do
    IO.puts zero_index
    current_index = elem(zeros, zero_index) 
    current_value = Enum.at(board, current_index) |> String.to_integer
    new_value = next_valid(board, current_index, current_value)
    if new_value do
      # if new_value is not nil, update the board string and move to next blank
      new_board = List.replace_at(board, current_index, new_value)
      solve_board( new_board, zeros, zero_index + 1 )
    else
      # backtrack to previous number
      new_board = List.replace_at(board, current_index, "0")
      solve_board( new_board, zeros, zero_index - 1 )
    end
  end

  def next_valid(_, _, 9), do: nil 
  
  def next_valid(board_array, index, current_value) do
    new_value = current_value + 1 |> Integer.to_string
    taken_numbers = row(board_array, index) ++ column(board_array, index) ++ grid(board_array, index)
    possible_solutions = @numbers -- Enum.uniq(taken_numbers)
    if Enum.any?(possible_solutions, &(&1 == new_value)) do
      new_value
    else
      next_valid(board_array, index, String.to_integer(new_value))
    end 
  end

  def row(board_array, index) do
    y = div index, 9
    board_array |> Enum.with_index |> Enum.filter( &( div( elem(&1, 1), 9) == y) ) |> Enum.map(&(elem(&1,0)))
  end

  def column(board_array, index) do
    x = rem index, 9
    board_array |> Enum.with_index |> Enum.filter( &( rem( elem(&1, 1), 9) == x) ) |> Enum.map(&(elem(&1,0)))
  end

  def grid(board_array, index) do
    target_top_left = find_top_left(index)
    board_array
      |> Enum.with_index
      |> Enum.filter(&( find_top_left(elem(&1,1)) == target_top_left) )
      |> Enum.map(&(elem(&1,0)))
  end

  def find_top_left(index) do
    top_left_y = div( div(index,9), 3 ) *3
    top_left_x = div( rem(index,9), 3 ) *3
    { top_left_x, top_left_y }
  end
end

IO.puts "Initial Board"
Sudoku.display_board(board_string)
Sudoku.solve(board_string)




