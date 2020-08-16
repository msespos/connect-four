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
    
    if @board[column - 1][0] == '-'
      @board[column  - 1][0] = token
    elsif @board[column - 1][0] != '-' && @board[column - 1][1] == '-'
      @board[column - 1][1] = token
    elsif @board[column - 1][0] != '-' && @board[column - 1][1] != '-' && @board[column - 1][2] == '-'
      @board[column - 1][2] = token
    elsif @board[column - 1][0] != '-' && @board[column - 1][1] != '-' && @board[column - 1][2] != '-' && @board[column - 1][3] == '-'
      @board[column - 1][3] = token
    end
  end
end