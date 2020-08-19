# frozen_string_literal: true

# board class
class Board
  def initialize
    board
  end

  def board
    @board = Array.new(7) { Array.new(6) { '-' } }
  end

  def drop_token(token, column)
    return :error if row_to_use(column) == :error

    @board[column][row_to_use(column)] = token
  end

  def row_status
    row_win? ? :win : :no_win_yet
  end

  def column_status
    column_win? ? :win : :no_win_yet
  end

  def negative_slope_diagonal_status
    negative_slope_diagonal_win? ? :win : :no_win_yet
  end

  def positive_slope_diagonal_status
    positive_slope_diagonal_win? ? :win : :no_win_yet
  end

  private

  def row_to_use(column)
    row = 0
    while row < 6
      return row if @board[column][row] == '-'

      row += 1
    end
    :error
  end

  def row_win?
    @board.each_with_index do |column, column_index|
      column.each_index do |row_index|
        next if column_index > 3 || @board[column_index][row_index] == '-'

        return true if four_consecutive_in_row?(column_index, row_index)
      end
    end
    false
  end

  def four_consecutive_in_row?(column_index, row_index)
    first_spot = @board[column_index][row_index]
    second_spot = @board[column_index + 1][row_index]
    third_spot = @board[column_index + 2][row_index]
    fourth_spot = @board[column_index + 3][row_index]
    first_spot == second_spot && first_spot == third_spot && first_spot == fourth_spot
  end

  def column_win?
    @board.each_with_index do |column, column_index|
      column.each_index do |row_index|
        next if row_index > 2 || @board[column_index][row_index] == '-'

        return true if four_consecutive_in_column?(column_index, row_index)
      end
    end
    false
  end

  def four_consecutive_in_column?(column_index, row_index)
    first_spot = @board[column_index][row_index]
    second_spot = @board[column_index][row_index + 1]
    third_spot = @board[column_index][row_index + 2]
    fourth_spot = @board[column_index][row_index + 3]
    first_spot == second_spot && first_spot == third_spot && first_spot == fourth_spot
  end

  def negative_slope_diagonal_win?
    @board.each_with_index do |column, column_index|
      column.each_index do |row_index|
        next if row_index < 3 || column_index > 3 || @board[column_index][row_index] == '-'

        return true if four_consecutive_in_negative_slope_diagonal?(column_index, row_index)
      end
    end
    false
  end

  def negative_slope_diagonal_spots(column_index, row_index)
    first_spot = @board[column_index][row_index]
    second_spot = @board[column_index + 1][row_index - 1]
    third_spot = @board[column_index + 2][row_index - 2]
    fourth_spot = @board[column_index + 3][row_index - 3]
    [first_spot, second_spot, third_spot, fourth_spot]
  end

  def four_consecutive_in_negative_slope_diagonal?(column_index, row_index)
    first_spot, second_spot, third_spot, fourth_spot = negative_slope_diagonal_spots(column_index, row_index)
    first_spot == second_spot && first_spot == third_spot && first_spot == fourth_spot
  end

  def positive_slope_diagonal_win?
    @board.each_with_index do |column, column_index|
      column.each_index do |row_index|
        next if row_index < 3 || column_index < 3 || @board[column_index][row_index] == '-'

        return true if four_consecutive_in_positive_slope_diagonal?(column_index, row_index)
      end
    end
    false
  end

  def positive_slope_diagonal_spots(column_index, row_index)
    first_spot = @board[column_index][row_index]
    second_spot = @board[column_index - 1][row_index - 1]
    third_spot = @board[column_index - 2][row_index - 2]
    fourth_spot = @board[column_index - 3][row_index - 3]
    [first_spot, second_spot, third_spot, fourth_spot]
  end

  def four_consecutive_in_positive_slope_diagonal?(column_index, row_index)
    first_spot, second_spot, third_spot, fourth_spot = positive_slope_diagonal_spots(column_index, row_index)
    first_spot == second_spot && first_spot == third_spot && first_spot == fourth_spot
  end
end
