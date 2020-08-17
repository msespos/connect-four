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
    if row_to_use(column) == :error
      return :error
    end
    @board[column - 1][row_to_use(column)] = token
  end

  private

  def row_to_use(column)
    row = 0
    while row < 6
      if @board[column - 1][row] == '-'
        return row
      end
      row += 1
    end
    :error
  end
end