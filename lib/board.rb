# frozen_string_literal: true

# board class
class Board

  def initialize
    @board = Array.new(7) { Array.new(6) { '-' } }
  end
end