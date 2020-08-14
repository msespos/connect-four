# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/connect_four.rb'

RSpec.describe Game do

  subject(:game) { Game.new }
  describe '#game_over' do
    context 'when the game is over' do
      it 'returns "Yellow wins!"' do
        expect(game.game_over(:yellow)).to eq("Yellow wins!")
      end

      it 'returns "Red wins!"' do
        expect(game.game_over(:red)).to eq("Red wins!")
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
