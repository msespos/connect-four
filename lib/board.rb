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

  private

  def row_to_use(column)
    row = 0
    while row < 6
      return row if @board[column][row] == '-'

      row += 1
    end
    :error
  end
end
