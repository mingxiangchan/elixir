defmodule SudokuParallel.Validation do
  @numbers String.codepoints("123456789")

  def get_potential_solutions(board, index) do
    board_array = Map.get(board, :cells)
    taken_numbers = row(board_array, index) ++ column(board_array, index) ++ grid(board_array, index)
    @numbers -- Enum.uniq(taken_numbers)
  end

  def row(board_array, index) do
    y = div index, 9
    board_array 
      |> Enum.with_index 
      |> Enum.filter( &( div( elem(&1, 1), 9) == y) ) 
      |> Enum.map(&(elem(&1,0)))
  end

  def column(board_array, index) do
    x = rem index, 9
    board_array 
      |> Enum.with_index 
      |> Enum.filter( &( rem( elem(&1, 1), 9) == x) ) 
      |> Enum.map(&(elem(&1,0)))
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
