# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/game.rb'

RSpec.describe Game do

  subject(:game) { Game.new }
  describe '#game_over?' do
    context 'when the game is over' do
      it 'returns "Yellow wins!"' do
        expect(game.game_over?(:yellow)).to eq("Yellow wins!")
      end

      it 'returns "Red wins!"' do
        expect(game.game_over?(:red)).to eq("Red wins!")
      end

      it 'returns "It\'s a draw!"' do
        expect(game.game_over?(:draw)).to eq("It\'s a draw!")
      end
    end

  describe '#outcome' do
    context 'when checking the game outcome'
      it 'returns :red if there are four reds in a row' do
        game.instance_variable_set(:@red, 4)
        expect(game.outcome).to eq(:red)
      end

      it 'returns :yellow if there are four yellows in a row' do
        game.instance_variable_set(:@yellow, 4)
        expect(game.outcome).to eq(:yellow)
      end

      it 'returns :draw if there are no winners and the board is full' do
        game.instance_variable_set(:@red, 3)
        game.instance_variable_set(:@yellow, 3)
        game.instance_variable_set(:@turns, 42)
        expect(game.outcome).to eq(:draw)
      end      
    end
  end  
end

# rubocop:enable Metrics/BlockLength
