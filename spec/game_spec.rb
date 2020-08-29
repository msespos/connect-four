# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/game.rb'

RSpec.describe Game do
  subject(:game) { described_class.new(board_end) }
  describe '#end_of_game_output' do
    context 'when the game is over with a leo win' do
      let(:board_end) { instance_double(Board, win_status: :leo) }
      it 'returns "Leo wins!"' do
        output = game.end_of_game_output
        expect(output).to eq('Leo wins!')
      end
    end

    context 'when the game is over with a do not enter win' do
      let(:board_end) { instance_double(Board, win_status: :do_not_enter) }
      it 'returns "Do Not Enter wins!"' do
        output = game.end_of_game_output
        expect(output).to eq('Do Not Enter wins!')
      end
    end

    context 'when the game is over with a tie' do
      let(:board_end) { instance_double(Board, win_status: :no_win_yet) }
      it 'returns "It\'s a draw!"' do
        output = game.end_of_game_output
        expect(output).to eq('It\'s a draw!')
      end
    end
  end

  describe '#game_over?' do
    subject(:game) { described_class.new(board_over) }
    context 'when the win status is :leo' do
      let(:board_over) { instance_double(Board, win_status: :leo) }
      it 'returns true' do
        game_over = game.game_over?
        expect(game_over).to eq(true)
      end
    end

    context 'when the win status is :do_not_enter' do
      let(:board_over) { instance_double(Board, win_status: :do_not_enter) }
      it 'returns true' do
        game_over = game.game_over?
        expect(game_over).to eq(true)
      end
    end

    context 'when 42 turns have been played' do
      let(:board_over) { instance_double(Board, win_status: :no_win_yet) }
      it 'returns true' do
        game.instance_variable_set(:@turns, 42)
        game_over = game.game_over?
        expect(game_over).to eq(true)
      end
    end

    context 'when the win status is :no_win_yet' do
      let(:board_over) { instance_double(Board, win_status: :no_win_yet) }
      it 'returns false' do
        game_over = game.game_over?
        expect(game_over).to eq(false)
      end
    end
  end

  describe '#play_turn' do
    subject(:game_play) { described_class.new(board_play) }
    let(:board_play) { instance_double(Board) }
    context 'when playing a leo token in column 1' do
      it 'calls Board#drop_token with :leo and 0' do
        allow(game_play).to receive(:game_over?).and_return(false)
        expect(board_play).to receive(:drop_token).with(Board::LEO_TOKEN, 0)
        game_play.play_turn(Board::LEO_TOKEN, 1)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
