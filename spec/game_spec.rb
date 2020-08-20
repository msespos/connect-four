# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/game.rb'

RSpec.describe Game do
  subject(:game) { Game.new }
  describe '#end_of_game_output' do
    context 'when the game is over with a yellow win' do
      it 'returns "Yellow wins!"' do
        expect(game.end_of_game_output(:yellow)).to eq('Yellow wins!')
      end
    end

    context 'when the game is over with a red win' do
      it 'returns "Red wins!"' do
        expect(game.end_of_game_output(:red)).to eq('Red wins!')
      end
    end

    context 'when the game is over with a tie' do
      it 'returns "It\'s a draw!"' do
        expect(game.end_of_game_output(:draw)).to eq('It\'s a draw!')
      end
    end
  end

  describe '#outcome' do
    context 'when checking the game outcome' do
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

  describe '#game_over?' do
    context 'when checking if the game is over' do
      it 'returns true if there are four reds in a row' do
        game.instance_variable_set(:@red, 4)
        expect(game.game_over?).to eq(true)
      end

      it 'returns true if there are four yellows in a row' do
        game.instance_variable_set(:@yellow, 4)
        expect(game.game_over?).to eq(true)
      end

      it 'returns true if the board is full' do
        game.instance_variable_set(:@turns, 42)
        expect(game.game_over?).to eq(true)
      end

      it 'returns if none of the conditions are true' do
        game.instance_variable_set(:@red, 3)
        game.instance_variable_set(:@yellow, 3)
        game.instance_variable_set(:@turns, 41)
        expect(game.game_over?).to eq(false)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
