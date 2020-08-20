# frozen_string_literal: true

# gameplay class
class Game
  def end_of_game_output(outcome)
    if outcome == :yellow
      'Yellow wins!'
    elsif outcome == :red
      'Red wins!'
    else
      'It\'s a draw!'
    end
  end

  def game_over?
    @red == 4 || @yellow == 4 || @turns == 42
  end

  def outcome
    if @red == 4
      :red
    elsif @yellow == 4
      :yellow
    elsif @turns == 42
      :draw
    end
  end
end
