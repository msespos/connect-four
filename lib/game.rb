# frozen_string_literal: true

# gameplay class
class Game
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

  private

  # used by #play_game to play one turn
  def play_turn
    token = obtain_token
    column = obtain_column
    @board.drop_token(token, column - 1)
    @turns += 1
    @player_number = @player_number == 1 ? 2 : 1
    puts @board.to_s
  end

  # used by #play_game to determine if the game is over
  def game_over?
    @board.win_status == :leo || @board.win_status == :do_not_enter || @turns == 42
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

  # used by #play_turn to get the current token to drop
  def obtain_token
    @player_number == 1 ? Board::LEO_TOKEN : Board::DO_NOT_ENTER_TOKEN
  end

  # used by #play_turn to get the current column to drop the token in
  def obtain_column
    puts "Player #{@player_number}, pick a column (1-7)"
    column = gets.chomp.to_i
    until [1, 2, 3, 4, 5, 6, 7].include?(column) && @board.row_to_use(column - 1) != :error
      puts 'Please enter a valid column number (1-7)'
      column = gets.chomp.to_i
    end
    column
  end
end
