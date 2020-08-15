# frozen_string_literal: true

# gameplay class
class Game

  def game_over?(outcome)
    if outcome == :yellow
      "Yellow wins!"
    elsif outcome == :red
      "Red wins!"
    else
      "It\'s a draw!"
    end
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