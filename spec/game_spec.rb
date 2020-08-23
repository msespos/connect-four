# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/game.rb'

RSpec.describe Game do
  subject(:game) { Game.new }
  describe '#end_of_game_output' do
    context 'when the game is over with a do_not_enter win' do
      it 'returns "Do Not Enter wins!"' do
        expect(game.end_of_game_output(:do_not_enter)).to eq('Do Not Enter wins!')
      end
    end

    context 'when the game is over with a leo win' do
      it 'returns "Leo wins!"' do
        expect(game.end_of_game_output(:leo)).to eq('Leo wins!')
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
      it 'returns :leo if there are four leos in a row' do
        game.instance_variable_set(:@leo, 4)
        expect(game.outcome).to eq(:leo)
      end

      it 'returns :do_not_enter if there are four do_not_enters in a row' do
        game.instance_variable_set(:@do_not_enter, 4)
        expect(game.outcome).to eq(:do_not_enter)
      end

      it 'returns :draw if there are no winners and the board is full' do
        game.instance_variable_set(:@leo, 3)
        game.instance_variable_set(:@do_not_enter, 3)
        game.instance_variable_set(:@turns, 42)
        expect(game.outcome).to eq(:draw)
      end
    end
  end

  describe '#game_over?' do
    context 'when checking if the game is over' do
      it 'returns true if there are four leos in a row' do
        game.instance_variable_set(:@leo, 4)
        expect(game.game_over?).to eq(true)
      end

      it 'returns true if there are four do_not_enters in a row' do
        game.instance_variable_set(:@do_not_enter, 4)
        expect(game.game_over?).to eq(true)
      end

      it 'returns true if the board is full' do
        game.instance_variable_set(:@turns, 42)
        expect(game.game_over?).to eq(true)
      end

      it 'returns if none of the conditions are true' do
        game.instance_variable_set(:@leo, 3)
        game.instance_variable_set(:@do_not_enter, 3)
        game.instance_variable_set(:@turns, 41)
        expect(game.game_over?).to eq(false)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
