# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/game.rb'

RSpec.describe Game do
  describe '#play_game' do
    subject(:game_play) { described_class.new }
    context 'when game_over? is false once' do
      before do
        allow(game_play).to receive(:game_over?).and_return(false, true)
      end
      it 'calls play_turn one time' do
        expect(game_play).to receive(:play_turn).once
        game_play.play_game
      end
    end

    context 'when game_over? is false twice' do
      before do
        allow(game_play).to receive(:game_over?).and_return(false, false, true)
      end
      it 'calls play_turn twice' do
        expect(game_play).to receive(:play_turn).twice
        game_play.play_game
      end
    end

    context 'when game_over? is false five times' do
      before do
        allow(game_play).to receive(:game_over?).and_return(false, false, false, false, false, true)
      end
      it 'calls play_turn five times' do
        expect(game_play).to receive(:play_turn).exactly(5).times
        game_play.play_game
      end
    end
  end

  describe '#play_turn' do
    subject(:game_play) { described_class.new(board_play) }
    let(:board_play) { instance_double(Board) }
    context 'when playing a leo token in column 1' do
      xit 'calls Board#drop_token with :leo and 0' do
        expect(board_play).to receive(:drop_token).with(Board::LEO_TOKEN, 0)
        game_play.play_turn(Board::LEO_TOKEN, 1)
      end
    end
  end

  describe '#game_over?' do
    subject(:game) { described_class.new(board_over) }
    context 'when the win status is :leo' do
      let(:board_over) { instance_double(Board, win_status: :leo) }
      xit 'returns true' do
        game_over = game.game_over?
        expect(game_over).to eq(true)
      end
    end

    context 'when the win status is :do_not_enter' do
      let(:board_over) { instance_double(Board, win_status: :do_not_enter) }
      xit 'returns true' do
        game_over = game.game_over?
        expect(game_over).to eq(true)
      end
    end

    context 'when 42 turns have been played' do
      let(:board_over) { instance_double(Board, win_status: :no_win_yet) }
      xit 'returns true' do
        game.instance_variable_set(:@turns, 42)
        game_over = game.game_over?
        expect(game_over).to eq(true)
      end
    end

    context 'when the win status is :no_win_yet' do
      let(:board_over) { instance_double(Board, win_status: :no_win_yet) }
      xit 'returns false' do
        game_over = game.game_over?
        expect(game_over).to eq(false)
      end
    end
  end

  describe '#end_of_game_output' do
    subject(:game) { described_class.new(board_end) }
    context 'when the game is over with a leo win' do
      let(:board_end) { instance_double(Board, win_status: :leo) }
      xit 'returns "Leo wins!"' do
        output = game.end_of_game_output
        expect(output).to eq('Leo wins!')
      end
    end

    context 'when the game is over with a do not enter win' do
      let(:board_end) { instance_double(Board, win_status: :do_not_enter) }
      xit 'returns "Do Not Enter wins!"' do
        output = game.end_of_game_output
        expect(output).to eq('Do Not Enter wins!')
      end
    end

    context 'when the game is over with a tie' do
      let(:board_end) { instance_double(Board, win_status: :no_win_yet) }
      xit 'returns "It\'s a draw!"' do
        output = game.end_of_game_output
        expect(output).to eq('It\'s a draw!')
      end
    end
  end

  # to be written:
  # describe '#obtain_token' do
  # context 'when it is Player 1' do
  # it 'returns a Leo token' do
  # end
  # end
  # end
end

# rubocop:enable Metrics/BlockLength
