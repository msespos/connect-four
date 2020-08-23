# frozen_string_literal: true

# gameplay class
class Game
  def end_of_game_output(outcome)
    if outcome == :do_not_enter
      'Do Not Enter wins!'
    elsif outcome == :leo
      'Leo wins!'
    else
      'It\'s a draw!'
    end
  end

  def game_over?
    @leo == 4 || @do_not_enter == 4 || @turns == 42
  end

  def outcome
    if @leo == 4
      :leo
    elsif @do_not_enter == 4
      :do_not_enter
    elsif @turns == 42
      :draw
    end
  end
end
