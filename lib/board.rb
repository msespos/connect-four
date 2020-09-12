# frozen_string_literal: true

# board class
class Board
  SHIFTS_BY_WIN_TYPE = {
    row: [1, 0],
    column: [0, 1],
    negative_slope_diagonal: [1, -1],
    positive_slope_diagonal: [-1, -1]
  }.freeze
  PLAYER_ONE_TOKEN = " \u264C".encode('utf-8').freeze
  PLAYER_TWO_TOKEN = " \u26D4".encode('utf-8').freeze

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

  # used by Game#obtain_column_check to verify that a column is not already full - tested
  def column_full?(column)
    row_to_use(column - 1).nil?
  end

  # determine if the board is in a player_one win, player_two win, or no_win_yet state - tested
  def win_status
    SHIFTS_BY_WIN_TYPE.each_key do |win_type|
      return token_to_symbol(winner_or_none(win_type)) if winner_or_none(win_type) != :no_win_yet
    end
    :no_win_yet
  end

  # the string that represents the game board during play - tested
  def to_s
    main_board + bottom_of_board
  end

  private

  # used by #drop_token to determine which row, if any, should be used to place a
  # token given a column - returns nil if the column is full already
  # also used by #column_full? to check for full columns - tested
  def row_to_use(column)
    row = 0
    while row < 6
      return row if @board[column][row] == ' - '

      row += 1
    end
    nil
  end

  # used by #win_status to determine the winner if there is a winner at this point in the game - tested
  def winner_or_none(win_type)
    @board.each_with_index do |column, column_index|
      column.each_index do |row_index|
        next if @board[column_index][row_index] == ' - '

        next if four_consecutive?(column_index, row_index, win_type).nil?

        return @board[column_index][row_index] if four_consecutive?(column_index, row_index, win_type)
      end
    end
    :no_win_yet
  end

  # used by #win_status to convert strings from #winner_or_none to their corresponding symbols - tested
  def token_to_symbol(winner_or_none)
    if winner_or_none == PLAYER_ONE_TOKEN
      :player_one
    elsif winner_or_none == PLAYER_TWO_TOKEN
      :player_two
    else
      :no_win_yet
    end
  end

  # used by #winner_or_none to check four spots given an initial spot to see if they are - not tested
  # consecutive of one color
  def four_consecutive?(column_index, row_index, win_type)
    return nil if win_spots(column_index, row_index, win_type).nil?

    first_spot, second_spot, third_spot, fourth_spot = win_spots(column_index, row_index, win_type)
    first_spot == second_spot && first_spot == third_spot && first_spot == fourth_spot
  end

  # used by #four_consecutive? to create the four spots to be checked using column and row
  # shifts as appropriate to the type of win - not tested
  def win_spots(column_index, row_index, win_type)
    column_shift, row_shift = SHIFTS_BY_WIN_TYPE[win_type]
    win_spots = []
    (0..3).each do |i|
      return nil unless valid_coordinates?(column_index + column_shift * i, row_index + row_shift * i)

      win_spots[i] = @board[column_index + column_shift * i][row_index + row_shift * i]
    end
    win_spots
  end

  # used by #win_spots to determine if the indices being examined are valid coordinates - not tested
  def valid_coordinates?(column_index, row_index)
    column_index >= 0 && column_index <= 6 && row_index >= 0 && row_index <= 5
  end

  # used by to_s to draw the main 7x6 board with spaces, tokens and borders - not tested
  # don't pass in a parameter - just build and return
  def main_board
    string = ''
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

  # used by to_s to draw the bottom section of the board - not tested
  # don't pass in a parameter - just build and return
  def bottom_of_board
    string = ''
    string += '    -' + '-' * 42 + "\n" + '    |'
    (1..7).each { |column_value| string += '  ' + column_value.to_s + '  |' }
    string += "\n\n"
  end
end
