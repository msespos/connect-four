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
        if column_index <= 3 && @board[column_index][row_index] != '-'
          if @board[column_index][row_index] == @board[column_index + 1][row_index] &&
            @board[column_index][row_index] == @board[column_index + 2][row_index] &&
            @board[column_index][row_index] == @board[column_index + 3][row_index]
            return true
          end
        end
      end
    end
    false
  end
end
