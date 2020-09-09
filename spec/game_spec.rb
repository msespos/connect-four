# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/game.rb'

RSpec.describe Game do
  describe '#initialize' do
    subject(:game_initialize) { described_class.new }
    context 'when Game class is instantiated with no argument for initialize' do
      it 'creates an instance of Board' do
        board = game_initialize.instance_variable_get(:@board)
        expect(board).to be_a(Board)
      end
    end

    context 'when Game class is instantiated with an argument for initialize' do
      subject(:game_initialize) { described_class.new(1) }
      it 'does not create an instance of Board' do
        board = game_initialize.instance_variable_get(:@board)
        expect(board).to_not be_a(Board)
      end
    end

    context 'when Game class is instantiated with no argument for initialize' do
      subject(:game_initialize) { described_class.new }
      it 'sets number of turns to 0' do
        turns = game_initialize.instance_variable_get(:@turns)
        expect(turns).to eq(0)
      end
    end

    context 'when Game class is instantiated with no argument for initialize' do
      subject(:game_initialize) { described_class.new }
      it 'sets number of turns to an integer' do
        turns = game_initialize.instance_variable_get(:@turns)
        expect(turns).to be_an(Integer)
      end
    end

    context 'when Game class is instantiated with no argument for initialize' do
      subject(:game_initialize) { described_class.new }
      it 'does not set number of turns to 1000' do
        turns = game_initialize.instance_variable_get(:@turns)
        expect(turns).not_to eq(1000)
      end
    end

    context 'when Game class is instantiated with no argument for initialize' do
      subject(:game_initialize) { described_class.new }
      it 'does not set number of turns to a string' do
        turns = game_initialize.instance_variable_get(:@turns)
        expect(turns).not_to be_a(String)
      end
    end

    context 'when Game class is instantiated with no argument for initialize' do
      subject(:game_initialize) { described_class.new }
      it 'sets player number to 1' do
        player_number = game_initialize.instance_variable_get(:@player_number)
        expect(player_number).to eq(1)
      end
    end

    context 'when Game class is instantiated with no argument for initialize' do
      subject(:game_initialize) { described_class.new }
      it 'sets player number to an integer' do
        player_number = game_initialize.instance_variable_get(:@player_number)
        expect(player_number).to be_an(Integer)
      end
    end

    context 'when Game class is instantiated with no argument for initialize' do
      subject(:game_initialize) { described_class.new }
      it 'does not set player number to 1000' do
        player_number = game_initialize.instance_variable_get(:@player_number)
        expect(player_number).not_to eq(1000)
      end
    end

    context 'when Game class is instantiated with no argument for initialize' do
      subject(:game_initialize) { described_class.new }
      it 'does not set player number to a string' do
        player_number = game_initialize.instance_variable_get(:@player_number)
        expect(player_number).not_to be_a(String)
      end
    end
  end

  describe '#play_game' do
    subject(:game_play) { described_class.new }
    context 'when game_over? is false once' do
      before do
        allow(game_play).to receive(:game_over?).and_return(false, true)
        allow(game_play).to receive(:puts)
      end
      it 'calls play_turn one time' do
        expect(game_play).to receive(:play_turn).once
        game_play.play_game
      end
    end

    context 'when game_over? is false twice' do
      before do
        allow(game_play).to receive(:game_over?).and_return(false, false, true)
        allow(game_play).to receive(:puts)
      end
      it 'calls play_turn twice' do
        expect(game_play).to receive(:play_turn).twice
        game_play.play_game
      end
    end

    context 'when game_over? is false five times' do
      before do
        allow(game_play).to receive(:game_over?).and_return(false, false, false, false, false, true)
        allow(game_play).to receive(:puts)
      end
      it 'calls play_turn five times' do
        expect(game_play).to receive(:play_turn).exactly(5).times
        game_play.play_game
      end
    end

    context 'when game_over? is true' do
      before do
        allow(game_play).to receive(:game_over?).and_return(true)
        allow(game_play).to receive(:end_of_game_output).and_return('End Of Game Output')
      end
      it 'prints the end of game output' do
        expect { game_play.play_game }.to output("End Of Game Output\n").to_stdout
      end
    end
  end

  describe '#play_turn' do
    subject(:game_turn) { described_class.new(board_turn) }
    let(:board_turn) { instance_double(Board) }
    context 'when playing a leo token in column 1' do
      before do
        allow(game_turn).to receive(:obtain_token).and_return(Board::LEO_TOKEN)
        allow(game_turn).to receive(:obtain_column).and_return(1)
        allow(game_turn).to receive(:puts)
      end
      it 'calls Board#drop_token with :leo and 0' do
        expect(board_turn).to receive(:drop_token).with(Board::LEO_TOKEN, 0)
        game_turn.send(:play_turn)
      end
    end

    context 'when playing a do not enter token in column 7' do
      before do
        allow(game_turn).to receive(:obtain_token).and_return(Board::DO_NOT_ENTER_TOKEN)
        allow(game_turn).to receive(:obtain_column).and_return(7)
        allow(game_turn).to receive(:puts)
      end
      it 'calls Board#drop_token with :do_not_enter and 6' do
        expect(board_turn).to receive(:drop_token).with(Board::DO_NOT_ENTER_TOKEN, 6)
        game_turn.send(:play_turn)
      end
    end

    context 'when playing a leo token in column 7 as the first turn' do
      before do
        allow(game_turn).to receive(:obtain_token).and_return(Board::LEO_TOKEN)
        allow(game_turn).to receive(:obtain_column).and_return(7)
        allow(board_turn).to receive(:drop_token)
        allow(game_turn).to receive(:puts)
      end
      it 'advances turn count from 0 to 1' do
        turns = game_turn.instance_variable_get(:@turns)
        expect(turns).to eq(0)
        game_turn.send(:play_turn)
        turns = game_turn.instance_variable_get(:@turns)
        expect(turns).to eq(1)
      end
    end

    context 'when playing a leo token in column 7 as the first turn' do
      before do
        allow(game_turn).to receive(:obtain_token).and_return(Board::LEO_TOKEN)
        allow(game_turn).to receive(:obtain_column).and_return(7)
        allow(board_turn).to receive(:drop_token)
        allow(game_turn).to receive(:puts)
      end
      it 'shifts player number from 1 to 2 and back to 1' do
        player_number = game_turn.instance_variable_get(:@player_number)
        expect(player_number).to eq(1)
        game_turn.send(:play_turn)
        player_number = game_turn.instance_variable_get(:@player_number)
        expect(player_number).to eq(2)
        game_turn.send(:play_turn)
        player_number = game_turn.instance_variable_get(:@player_number)
        expect(player_number).to eq(1)
      end
    end

    context 'when one turn is played' do
      before do
        allow(game_turn).to receive(:obtain_token).and_return(Board::LEO_TOKEN)
        allow(game_turn).to receive(:obtain_column).and_return(7)
        allow(board_turn).to receive(:drop_token)
        allow(game_turn).to receive(:puts)
        allow(game_turn).to receive(:@board).and_return('The Board')
      end
      xit 'prints the board' do
        expect { game_turn.send(:play_turn) }.to output("The Board\n").to_stdout
      end
    end
  end

  describe '#game_over?' do
    subject(:game) { described_class.new(board_over) }
    context 'when the win status is :leo' do
      let(:board_over) { instance_double(Board, win_status: :leo) }
      it 'returns true' do
        game_over = game.send(:game_over?)
        expect(game_over).to eq(true)
      end
    end

    context 'when the win status is :do_not_enter' do
      let(:board_over) { instance_double(Board, win_status: :do_not_enter) }
      it 'returns true' do
        game_over = game.send(:game_over?)
        expect(game_over).to eq(true)
      end
    end

    context 'when 42 turns have been played' do
      let(:board_over) { instance_double(Board, win_status: :no_win_yet) }
      it 'returns true' do
        game.instance_variable_set(:@turns, 42)
        game_over = game.send(:game_over?)
        expect(game_over).to eq(true)
      end
    end

    context 'when the win status is :no_win_yet' do
      let(:board_over) { instance_double(Board, win_status: :no_win_yet) }
      it 'returns false' do
        game_over = game.send(:game_over?)
        expect(game_over).to eq(false)
      end
    end
  end

  describe '#end_of_game_output' do
    subject(:game) { described_class.new(board_end) }
    context 'when the game is over with a leo win' do
      let(:board_end) { instance_double(Board, win_status: :leo) }
      it 'returns "Leo wins!"' do
        output = game.send(:end_of_game_output)
        expect(output).to eq('Leo wins!')
      end
    end

    context 'when the game is over with a do not enter win' do
      let(:board_end) { instance_double(Board, win_status: :do_not_enter) }
      it 'returns "Do Not Enter wins!"' do
        output = game.send(:end_of_game_output)
        expect(output).to eq('Do Not Enter wins!')
      end
    end

    context 'when the game is over with a tie' do
      let(:board_end) { instance_double(Board, win_status: :no_win_yet) }
      it 'returns "It\'s a draw!"' do
        output = game.send(:end_of_game_output)
        expect(output).to eq('It\'s a draw!')
      end
    end
  end

  describe '#obtain_token' do
    subject(:game) { described_class.new }
    context 'when it is Player 1' do
      it 'returns a Leo token' do
        token = game.send(:obtain_token)
        expect(token).to eq(Board::LEO_TOKEN)
      end
    end

    context 'when it is Player 2' do
      subject(:game) { described_class.new(Board.new, 0, 2) }
      it 'returns a Do Not Enter token' do
        token = game.send(:obtain_token)
        expect(token).to eq(Board::DO_NOT_ENTER_TOKEN)
      end
    end
  end

  describe '#obtain_column' do
    subject(:game) { described_class.new }
    context 'when player number is 1' do
      before do
        allow(game).to receive(:gets).and_return('1')
      end
      it 'prints a prompt' do
        expect { game.send(:obtain_column) }.to output("Player 1, pick a column (1-7)\n").to_stdout
        allow(game).to receive(:puts)
        game.send(:obtain_column)
      end

      it 'sets column to 1' do
        expect { game.send(:obtain_column) }.to output("Player 1, pick a column (1-7)\n").to_stdout
        allow(game).to receive(:puts)
        game.send(:obtain_column)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
