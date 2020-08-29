# frozen_string_literal: true

# gameplay class
class Game
  LEO_TOKEN = " \u264C".encode('utf-8').freeze
  DO_NOT_ENTER_TOKEN = " \u26D4".encode('utf-8').freeze

  def initialize(board = Board.new)
    @board = board
    @turns = 0
    @player_number = 1
  end

  # play the entire game
  def play_game
    play_turn until game_over?
    puts end_of_game_output
  end

  # used by #play_game to determine if the game is over
  def game_over?
    @board.win_status == :leo || @board.win_status == :do_not_enter || @turns == 42
  end

  # used by #play_game to play one turn
  def play_turn
    token = obtain_token
    column = obtain_column.to_i
    @board.drop_token(token, column - 1)
    @turns += 1
    @player_number = @player_number == 1 ? 2 : 1
    puts @board.to_s
  end

  # used by #play_turn to get the current token to drop
  def obtain_token
    @player_number == 1 ? LEO_TOKEN : DO_NOT_ENTER_TOKEN
  end

  # used by #play_turn to get the current column to drop the token in
  def obtain_column
    puts "Player #{@player_number}, pick a column (1-7)"
    gets.chomp
  end

  # used by #play_game to generate the end-of-game output string
  def end_of_game_output
    if @board.win_status == :leo
      'Leo wins!'
    elsif @board.win_status == :do_not_enter
      'Do Not Enter wins!'
    else
      'It\'s a draw!'
    end
  end
end
