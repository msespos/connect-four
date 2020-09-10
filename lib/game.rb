# frozen_string_literal: true

# gameplay class
class Game
  def initialize
    @board = Board.new
    @turns = 0
    @player_number = 1
  end

  # play the entire game
  def play_game
    play_turn until game_over?
    puts end_of_game_output
  end

  private

  # used by #play_game to play one turn
  def play_turn
    token = obtain_token
    column = obtain_column
    @board.drop_token(token, column - 1)
    @turns += 1
    @player_number = @player_number == 1 ? 2 : 1
    puts @board
  end

  # used by #play_game to determine if the game is over
  def game_over?
    @board.win_status == :player_one || @board.win_status == :player_two || @turns == 42
  end

  # used by #play_game to generate the end-of-game output string
  def end_of_game_output
    if @board.win_status == :player_one
      'Player 1 wins!'
    elsif @board.win_status == :player_two
      'Player 2 wins!'
    else
      'It\'s a draw!'
    end
  end

  # used by #play_turn to get the current token to drop
  def obtain_token
    @player_number == 1 ? Board::PLAYER_ONE_TOKEN : Board::PLAYER_TWO_TOKEN
  end

  # used by #play_turn to get the current column to drop the token in
  def obtain_column
    puts "Player #{@player_number}, pick a column (1-7)"
    column = gets.chomp.to_i
    obtain_column_check(column)
  end

  # used by #obtain_column to check that the given column is valid and prompt if not
  def obtain_column_check(column)
    until column_valid_number?(column) && !@board.column_full?(column)
      puts 'Please enter a valid column number (1-7)'
      column = gets.chomp.to_i
    end
    column
  end

  # used by #obtain_column_check to verify that a column is a valid number
  def column_valid_number?(column)
    [1, 2, 3, 4, 5, 6, 7].include?(column)
  end
end
