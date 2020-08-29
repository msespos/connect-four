# frozen_string_literal: true

# gameplay class
class Game
  def initialize(board = Board.new)
    @board = board
  end

  def end_of_game_output
    if @board.win_status == :leo
      'Leo wins!'
    elsif @board.win_status == :do_not_enter
      'Do Not Enter wins!'
    else
      'It\'s a draw!'
    end
  end

  def game_over?
    @board.win_status == :leo || @board.win_status == :do_not_enter || @turns == 42
  end

  def play_turn(token, column)
    @board.drop_token(token, column - 1)
    puts end_of_game_output(outcome) if game_over?
  end
end
