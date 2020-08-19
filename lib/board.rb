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
    win?(:row) ? :win : :no_win_yet
  end

  def column_status
    win?(:column) ? :win : :no_win_yet
  end

  def negative_slope_diagonal_status
    win?(:negative_slope_diagonal) ? :win : :no_win_yet
  end

  def positive_slope_diagonal_status
    win?(:positive_slope_diagonal) ? :win : :no_win_yet
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

  def win?(win_type)
    @board.each_with_index do |column, column_index|
      column.each_index do |row_index|
        case win_type
        when :row
          next if column_index > 3 || @board[column_index][row_index] == '-'
        when :column
          next if row_index > 2 || @board[column_index][row_index] == '-'
        when :negative_slope_diagonal
          next if row_index < 3 || column_index > 3 || @board[column_index][row_index] == '-'
        when :positive_slope_diagonal
          next if row_index < 3 || column_index < 3 || @board[column_index][row_index] == '-'
        end

        return true if four_consecutive?(column_index, row_index, win_type)
      end
    end
    false
  end

  def four_consecutive?(column_index, row_index, win_type)
    first_spot, second_spot, third_spot, fourth_spot = win_spots(column_index, row_index, win_type)
    first_spot == second_spot && first_spot == third_spot && first_spot == fourth_spot
  end

  def win_spots(column_index, row_index, win_type)
    first_spot = @board[column_index][row_index]
    case win_type
    when :row
      second_spot = @board[column_index + 1][row_index]
      third_spot = @board[column_index + 2][row_index]
      fourth_spot = @board[column_index + 3][row_index]
    when :column
      second_spot = @board[column_index][row_index + 1]
      third_spot = @board[column_index][row_index + 2]
      fourth_spot = @board[column_index][row_index + 3]
    when :negative_slope_diagonal
      second_spot = @board[column_index + 1][row_index - 1]
      third_spot = @board[column_index + 2][row_index - 2]
      fourth_spot = @board[column_index + 3][row_index - 3]
    when :positive_slope_diagonal
      second_spot = @board[column_index - 1][row_index - 1]
      third_spot = @board[column_index - 2][row_index - 2]
      fourth_spot = @board[column_index - 3][row_index - 3]
    end
    [first_spot, second_spot, third_spot, fourth_spot]
  end
end
