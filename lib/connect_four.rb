class Game
  def game_over(outcome)
    outcome == :yellow ? "Yellow wins!" : "Red wins!"
  end
end