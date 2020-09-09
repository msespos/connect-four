# frozen_string_literal: true

# change symbols to NIL as appropriate

# change leo/DNE to P1/P2

# board class
class Board
  COLUMN_SHIFTS = [1, 0, 1, -1].freeze
  ROW_SHIFTS = [0, 1, -1, -1].freeze
  # make this a hash - pointing to row, column above
  WIN_TYPES = %i[row column negative_slope_diagonal positive_slope_diagonal].freeze
  LEO_TOKEN = " \u264C".encode('utf-8').freeze
  DO_NOT_ENTER_TOKEN = " \u26D4".encode('utf-8').freeze

  def initialize
    board
  end

  # build a blank board - tested
  def board
    @board = Array.new(7) { Array.new(6) { ' - ' } }
  end

  # drop a token into one of the columns on the board, assuming a slot is available - tested
  def drop_token(token, column)
    return if row_to_use(column).nil?

    @board[column][row_to_use(column)] = token
  end

  # used by #drop_token to determine which row, if any, should be used to place a
  # token given a column - returns nil if the column is full already
  # also used by Game#obtain_column to check for full columns - tested

  # add column_full? method and move row_to_use to private

  def row_to_use(column)
    row = 0
    while row < 6
      return row if @board[column][row] == ' - '

      row += 1
    end
    nil
  end

  # determine if the board is in a leo win, do_not_enter win, or no win yet state - tested
  def win_status
    # WIN_TYPES.keys.each
    WIN_TYPES.each do |win_type|
      return win_type_to_symbol(winner_or_none(win_type)) if winner_or_none(win_type) != :no_win_yet
    end
    :no_win_yet
  end

  # the string that represents the game board during play - tested
  def to_s
    string = ''
    # concatenate the different parts
    bottom_of_board(main_board(string))
  end

  private

  # used by #win_status to determine the winner if there is a winner at this point in the game - not tested
  def winner_or_none(win_type)
    @board.each_with_index do |column, column_index|
      column.each_index do |row_index|
        next if @board[column_index][row_index] == ' - '

        next if four_consecutive?(column_index, row_index, win_type) == :invalid

        return @board[column_index][row_index] if four_consecutive?(column_index, row_index, win_type)
      end
    end
    :no_win_yet
  end

  # used by #win_status to convert strings from #winner_or_none to their corresponding symbols - not tested
  def win_type_to_symbol(win_type)
    if win_type == LEO_TOKEN
      :leo
    elsif win_type == DO_NOT_ENTER_TOKEN
      :do_not_enter
    else
      :no_win_yet
    end
  end

  # used by #winner_or_none to check four spots given an initial spot to see if they are - not tested
  # consecutive of one color
  def four_consecutive?(column_index, row_index, win_type)
    return :invalid if win_spots(column_index, row_index, win_type) == :invalid

    first_spot, second_spot, third_spot, fourth_spot = win_spots(column_index, row_index, win_type)
    first_spot == second_spot && first_spot == third_spot && first_spot == fourth_spot
  end

  # used by #four_consecutive? to create the four spots to be checked using column and row
  # shifts as appropriate to the type of win - not tested
  def win_spots(column_index, row_index, win_type)
    column_shift, row_shift = shifts(win_type)
    win_spots = []
    (0..3).each do |i|
      return :invalid unless valid_coordinates?(column_index + column_shift * i, row_index + row_shift * i)

      win_spots[i] = @board[column_index + column_shift * i][row_index + row_shift * i]
    end
    win_spots
  end

  # used by #win_spots to generate the appropriate column and row shifts according to win_type
  # rewrite or remove? becomes a lookup - not tested
  def shifts(win_type)
    column_shift = 0
    row_shift = 0
    WIN_TYPES.each_with_index do |w_type, index|
      if w_type == win_type
        column_shift = COLUMN_SHIFTS[index]
        row_shift = ROW_SHIFTS[index]
      end
    end
    [column_shift, row_shift]
  end

  # used by #win_spots to determine if the indices being examined are valid coordinates - not tested
  def valid_coordinates?(column_index, row_index)
    column_index >= 0 && column_index <= 6 && row_index >= 0 && row_index <= 5
  end

  # used by to_s to draw the main 7x6 board with spaces, tokens and borders
  # don't pass in a parameter - just build and return
  def main_board(string)
    (0..5).each do |row|
      string += '    |' + '     |' * 7 + "\n   "
      (0..6).each do |column|
        rows = ' | ' + @board[column][5 - row].to_s
        string += rows
      end
      string += " |\n    " + '|     ' * 7 + "|\n"
    end
    string
  end

  # used by to_s to draw the bottom section of the board
  # don't pass in a parameter - just build and return
  def bottom_of_board(string)
    string += '    -' + '-' * 42 + "\n" + '    |'
    (1..7).each { |column_value| string += '  ' + column_value.to_s + '  |' }
    string += "\n\n"
  end
end
