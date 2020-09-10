# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/game.rb'

RSpec.describe Game do
  describe '#initialize' do
    subject(:game_initialize) { described_class.new }
    context 'when Game class is instantiated' do
      it 'creates an instance of Board' do
        board = game_initialize.instance_variable_get(:@board)
        expect(board).to be_a(Board)
      end

      it 'sets number of turns to 0' do
        turns = game_initialize.instance_variable_get(:@turns)
        expect(turns).to eq(0)
      end

      it 'sets number of turns to an integer' do
        turns = game_initialize.instance_variable_get(:@turns)
        expect(turns).to be_an(Integer)
      end

      it 'does not set number of turns to 1000' do
        turns = game_initialize.instance_variable_get(:@turns)
        expect(turns).not_to eq(1000)
      end

      it 'does not set number of turns to a string' do
        turns = game_initialize.instance_variable_get(:@turns)
        expect(turns).not_to be_a(String)
      end

      it 'sets player number to 1' do
        player_number = game_initialize.instance_variable_get(:@player_number)
        expect(player_number).to eq(1)
      end

      it 'sets player number to an integer' do
        player_number = game_initialize.instance_variable_get(:@player_number)
        expect(player_number).to be_an(Integer)
      end

      it 'does not set player number to 1000' do
        player_number = game_initialize.instance_variable_get(:@player_number)
        expect(player_number).not_to eq(1000)
      end

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
    subject(:game_turn) { described_class.new }
    let(:board_turn) { instance_double(Board) }
    context 'when playing a player_one token in column 1' do
      before do
        allow(game_turn).to receive(:obtain_token).and_return(Board::PLAYER_ONE_TOKEN)
        allow(game_turn).to receive(:obtain_column).and_return(1)
        allow(game_turn).to receive(:puts)
        game_turn.instance_variable_set(:@board, board_turn)
      end
      it 'calls Board#drop_token with :player_one and 0' do
        expect(board_turn).to receive(:drop_token).with(Board::PLAYER_ONE_TOKEN, 0)
        game_turn.send(:play_turn)
      end
    end

    context 'when playing a do not enter token in column 7' do
      before do
        allow(game_turn).to receive(:obtain_token).and_return(Board::PLAYER_TWO_TOKEN)
        allow(game_turn).to receive(:obtain_column).and_return(7)
        allow(game_turn).to receive(:puts)
        game_turn.instance_variable_set(:@board, board_turn)
      end
      it 'calls Board#drop_token with :player_two and 6' do
        expect(board_turn).to receive(:drop_token).with(Board::PLAYER_TWO_TOKEN, 6)
        game_turn.send(:play_turn)
      end
    end

    context 'when playing a player_one token in column 7 as the first turn' do
      before do
        allow(game_turn).to receive(:obtain_token).and_return(Board::PLAYER_ONE_TOKEN)
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

    context 'when playing a player_one token in column 7 as the first turn' do
      before do
        allow(game_turn).to receive(:obtain_token).and_return(Board::PLAYER_ONE_TOKEN)
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

    # integration test; also tests Board#to_s a fair amount - comment from AA
    context 'when one turn is played' do
      before do
        allow(game_turn).to receive(:obtain_token).and_return(Board::PLAYER_ONE_TOKEN)
        allow(game_turn).to receive(:obtain_column).and_return(7)
        allow(board_turn).to receive(:drop_token)
      end
      it 'prints the board' do
        expect { game_turn.send(:play_turn) }.to output(<<-BOARD).to_stdout
    |     |     |     |     |     |     |     |
    |  -  |  -  |  -  |  -  |  -  |  -  |  -  |
    |     |     |     |     |     |     |     |
    |     |     |     |     |     |     |     |
    |  -  |  -  |  -  |  -  |  -  |  -  |  -  |
    |     |     |     |     |     |     |     |
    |     |     |     |     |     |     |     |
    |  -  |  -  |  -  |  -  |  -  |  -  |  -  |
    |     |     |     |     |     |     |     |
    |     |     |     |     |     |     |     |
    |  -  |  -  |  -  |  -  |  -  |  -  |  -  |
    |     |     |     |     |     |     |     |
    |     |     |     |     |     |     |     |
    |  -  |  -  |  -  |  -  |  -  |  -  |  -  |
    |     |     |     |     |     |     |     |
    |     |     |     |     |     |     |     |
    |  -  |  -  |  -  |  -  |  -  |  -  |  ♌ |
    |     |     |     |     |     |     |     |
    -------------------------------------------
    |  1  |  2  |  3  |  4  |  5  |  6  |  7  |

        BOARD
      end
    end
  end

  describe '#game_over?' do
    subject(:game_over) { described_class.new }
    context 'when the win status is :player_one' do
      let(:board_over) { instance_double(Board, win_status: :player_one) }
      it 'returns true' do
        game_over.instance_variable_set(:@board, board_over)
        g_o = game_over.send(:game_over?)
        expect(g_o).to eq(true)
      end
    end

    context 'when the win status is :player_two' do
      let(:board_over) { instance_double(Board, win_status: :player_two) }
      it 'returns true' do
        game_over.instance_variable_set(:@board, board_over)
        g_o = game_over.send(:game_over?)
        expect(g_o).to eq(true)
      end
    end

    context 'when 42 turns have been played' do
      let(:board_over) { instance_double(Board, win_status: :no_win_yet) }
      it 'returns true' do
        game_over.instance_variable_set(:@turns, 42)
        g_o = game_over.send(:game_over?)
        expect(g_o).to eq(true)
      end
    end

    context 'when the win status is :no_win_yet' do
      let(:board_over) { instance_double(Board, win_status: :no_win_yet) }
      it 'returns false' do
        g_o = game_over.send(:game_over?)
        expect(g_o).to eq(false)
      end
    end
  end

  describe '#end_of_game_output' do
    subject(:game_end) { described_class.new }
    context 'when the game is over with a player_one win' do
      let(:board_end) { instance_double(Board, win_status: :player_one) }
      it 'returns "Player 1 wins!"' do
        game_end.instance_variable_set(:@board, board_end)
        output = game_end.send(:end_of_game_output)
        expect(output).to eq('Player 1 wins!')
      end
    end

    context 'when the game is over with a do not enter win' do
      let(:board_end) { instance_double(Board, win_status: :player_two) }
      it 'returns "Player 2 wins!"' do
        game_end.instance_variable_set(:@board, board_end)
        output = game_end.send(:end_of_game_output)
        expect(output).to eq('Player 2 wins!')
      end
    end

    context 'when the game is over with a tie' do
      let(:board_end) { instance_double(Board, win_status: :no_win_yet) }
      it 'returns "It\'s a draw!"' do
        game_end.instance_variable_set(:@board, board_end)
        output = game_end.send(:end_of_game_output)
        expect(output).to eq('It\'s a draw!')
      end
    end
  end

  describe '#obtain_token' do
    subject(:game) { described_class.new }
    context 'when it is Player 1' do
      it 'returns a player_one token' do
        token = game.send(:obtain_token)
        expect(token).to eq(Board::PLAYER_ONE_TOKEN)
      end
    end

    context 'when it is Player 2' do
      subject(:game) { described_class.new }
      it 'returns a Do Not Enter token' do
        game.instance_variable_set(:@player_number, 2)
        token = game.send(:obtain_token)
        expect(token).to eq(Board::PLAYER_TWO_TOKEN)
      end
    end
  end

  # did not test puts or gets line of this method
  describe '#obtain_column' do
    subject(:game_obtain) { described_class.new }
    context 'when player number is 1' do
      before do
        allow(game_obtain).to receive(:gets).and_return('1')
      end
      it 'prints a prompt' do
        expect { game_obtain.send(:obtain_column) }.to output("Player 1, pick a column (1-7)\n").to_stdout
        allow(game_obtain).to receive(:puts)
        game_obtain.send(:obtain_column)
      end

      it 'sets column to 1' do
        expect { game_obtain.send(:obtain_column) }.to output("Player 1, pick a column (1-7)\n").to_stdout
        allow(game_obtain).to receive(:puts)
        game_obtain.send(:obtain_column)
      end
    end
  end

  describe '#obtain_column_check' do
    subject(:game_check) { described_class.new }
    context 'when column is not a valid number once at the same time as column is full once' do
      before do
        allow(game_check).to receive(:column_valid_number?).and_return(false, true)
        allow(game_check).to receive(:game_over?).and_return(false, true)
        allow(game_check).to receive(:puts)
        allow(game_check).to receive(:gets).and_return('1')
      end
      it 'loops once' do
        expect(game_check).to receive(:obtain_column_check).once
        game_check.send(:obtain_column_check, 1)
      end
    end

    context 'when column is not a valid number once and then column is full once' do
      before do
        allow(game_check).to receive(:column_valid_number?).and_return(false, true, true)
        allow(game_check).to receive(:game_over?).and_return(true, false, true)
        allow(game_check).to receive(:puts)
        allow(game_check).to receive(:gets).and_return('1', '1')
      end
      it 'loops twice' do
        expect(game_check).to receive(:obtain_column_check).twice
        game_check.send(:obtain_column_check, 1)
        game_check.send(:obtain_column_check, 1)
      end
    end

    context 'when column is a valid number and column is not full' do
      before do
        allow(game_check).to receive(:column_valid_number?).and_return(true)
        allow(game_check).to receive(:game_over?).and_return(true)
      end
      it 'returns a column' do
        column = game_check.send(:obtain_column_check, 1)
        expect(column).to eq(1)
      end
    end
  end

  describe '#column_valid_number?' do
    subject(:game_valid) { described_class.new }
    context 'when column is not a valid number' do
      it 'returns false' do
        validation_check = game_valid.send(:column_valid_number?, 1000)
        expect(validation_check).to eq(false)
      end
    end

    context 'when column is a valid number' do
      it 'returns true' do
        validation_check = game_valid.send(:column_valid_number?, 7)
        expect(validation_check).to eq(true)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
