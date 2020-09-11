# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/board.rb'

RSpec.describe Board do
  subject(:board) { Board.new }
  describe '#initialize' do
    context 'when the board class is instantiated' do
      it 'calls the #board method' do
        expect(board).to receive(:board)
        board.send(:initialize)
      end
    end
  end

  describe '#board' do
    context 'when #board is called' do
      it 'generates a 6 row board' do
        expect(board.instance_variable_get(:@board)[0].size).to eq(6)
      end

      it 'generates a 7 column board' do
        expect(board.instance_variable_get(:@board).size).to eq(7)
      end

      it 'generates a board with " - " in the bottom left spot' do
        expect(board.instance_variable_get(:@board)[0][0]).to eq(' - ')
      end

      it 'generates a board with " - " in the bottom right spot' do
        expect(board.instance_variable_get(:@board)[6][0]).to eq(' - ')
      end
    end
  end

  describe '#drop_token' do
    context 'when the board is empty and a token is dropped in the first column' do
      it 'lands at the bottom of the first column' do
        board.drop_token(Board::PLAYER_ONE_TOKEN, 0)
        expect(board.instance_variable_get(:@board)[0][0]).to eq(Board::PLAYER_ONE_TOKEN)
      end
    end

    context 'when the bottom left spot is full and a token is dropped in the first column' do
      it 'lands at the second from the bottom spot of the first column' do
        board.instance_variable_get(:@board)[0][0] = Board::PLAYER_ONE_TOKEN
        board.drop_token(Board::PLAYER_TWO_TOKEN, 0)
        expect(board.instance_variable_get(:@board)[0][1]).to eq(Board::PLAYER_TWO_TOKEN)
      end
    end

    context 'when the bottom left spot is full and a token is dropped in the second column' do
      it 'lands at the bottom spot of the second column' do
        board.instance_variable_get(:@board)[0][0] = Board::PLAYER_ONE_TOKEN
        board.drop_token(Board::PLAYER_TWO_TOKEN, 1)
        expect(board.instance_variable_get(:@board)[1][0]).to eq(Board::PLAYER_TWO_TOKEN)
      end
    end

    context 'when the bottom two spots of the first column are full and a token is dropped in the first column' do
      it 'lands at the third from the bottom spot of the first column' do
        board.instance_variable_get(:@board)[0][0] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[0][1] = Board::PLAYER_TWO_TOKEN
        board.drop_token(Board::PLAYER_ONE_TOKEN, 0)
        expect(board.instance_variable_get(:@board)[0][2]).to eq(Board::PLAYER_ONE_TOKEN)
      end
    end

    context 'when the bottom three spots of the first column are full and a token is dropped in the first column' do
      it 'lands at the fourth from the bottom spot of the first column' do
        board.instance_variable_get(:@board)[0][0] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[0][1] = Board::PLAYER_TWO_TOKEN
        board.instance_variable_get(:@board)[0][2] = Board::PLAYER_ONE_TOKEN
        board.drop_token(Board::PLAYER_TWO_TOKEN, 0)
        expect(board.instance_variable_get(:@board)[0][3]).to eq(Board::PLAYER_TWO_TOKEN)
      end
    end
  end

  describe '#column_full?' do
    subject(:board_full) { described_class.new }
    context 'when column is full' do
      it 'returns true' do
        allow(board_full).to receive(:row_to_use).and_return(nil)
        full_check = board_full.column_full?(1)
        expect(full_check).to eq(true)
      end
    end

    context 'when column is not full' do
      it 'returns false' do
        allow(board_full).to receive(:row_to_use).and_return(5)
        full_check = board_full.column_full?(1)
        expect(full_check).to eq(false)
      end
    end
  end

  describe '#win_status' do
    context 'when there are four player_ones in a row along the bottom from columns 1 to 4' do
      it 'returns :PLAYER_ONE' do
        board.instance_variable_get(:@board)[0][0] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[1][0] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[2][0] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[3][0] = Board::PLAYER_ONE_TOKEN
        expect(board.win_status).to eq(:player_one)
      end
    end

    context 'when there are four player_ones in a row placed along the top from columns 4 to 7' do
      it 'returns :PLAYER_ONE' do
        board.instance_variable_get(:@board)[3][5] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[4][5] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[5][5] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[6][5] = Board::PLAYER_ONE_TOKEN
        expect(board.win_status).to eq(:player_one)
      end
    end

    context 'when there only two in a row along the bottom in columns 2 and 3' do
      it 'returns :no_win_yet' do
        board.instance_variable_get(:@board)[0][0] = Board::PLAYER_TWO_TOKEN
        board.instance_variable_get(:@board)[1][0] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[2][0] = Board::PLAYER_ONE_TOKEN
        expect(board.win_status).to eq(:no_win_yet)
      end
    end

    context 'when there are only three in a row along the bottom in columns 5 through 7' do
      it 'returns :no_win_yet' do
        board.instance_variable_get(:@board)[0][0] = Board::PLAYER_TWO_TOKEN
        board.instance_variable_get(:@board)[1][0] = Board::PLAYER_TWO_TOKEN
        board.instance_variable_get(:@board)[4][0] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[5][0] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[6][0] = Board::PLAYER_ONE_TOKEN
        expect(board.win_status).to eq(:no_win_yet)
      end
    end

    context 'when there are four player_ones in a column along the left from rows 1 to 4' do
      it 'returns :player_one' do
        board.instance_variable_get(:@board)[0][0] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[0][1] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[0][2] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[0][3] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[1][0] = Board::PLAYER_TWO_TOKEN
        board.instance_variable_get(:@board)[1][1] = Board::PLAYER_TWO_TOKEN
        board.instance_variable_get(:@board)[1][2] = Board::PLAYER_TWO_TOKEN
        expect(board.win_status).to eq(:player_one)
      end
    end

    context 'when there are four player_twos in a column unrealistically placed from rows 4 to 7' do
      it 'returns :player_two' do
        board.instance_variable_get(:@board)[5][0] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[5][1] = Board::PLAYER_TWO_TOKEN
        board.instance_variable_get(:@board)[5][2] = Board::PLAYER_TWO_TOKEN
        board.instance_variable_get(:@board)[5][3] = Board::PLAYER_TWO_TOKEN
        board.instance_variable_get(:@board)[5][4] = Board::PLAYER_TWO_TOKEN
        board.instance_variable_get(:@board)[5][5] = Board::PLAYER_TWO_TOKEN
        expect(board.win_status).to eq(:player_two)
      end
    end

    context 'when there only two in a column along the left side in rows 2 and 3' do
      it 'returns :no_win_yet' do
        board.instance_variable_get(:@board)[0][0] = Board::PLAYER_TWO_TOKEN
        board.instance_variable_get(:@board)[1][0] = Board::PLAYER_TWO_TOKEN
        board.instance_variable_get(:@board)[0][1] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[0][2] = Board::PLAYER_ONE_TOKEN
        expect(board.win_status).to eq(:no_win_yet)
      end
    end

    context 'when there are only three in a column placed along the left side in rows 5 through 7' do
      it 'returns :no_win_yet' do
        board.instance_variable_get(:@board)[1][0] = Board::PLAYER_TWO_TOKEN
        board.instance_variable_get(:@board)[2][0] = Board::PLAYER_TWO_TOKEN
        board.instance_variable_get(:@board)[3][0] = Board::PLAYER_TWO_TOKEN
        board.instance_variable_get(:@board)[4][0] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[5][0] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[6][0] = Board::PLAYER_ONE_TOKEN
        expect(board.win_status).to eq(:no_win_yet)
      end
    end

    context 'when there are four player_twos in a row diagonally from the top left spot' do
      it 'returns :player_two' do
        board.instance_variable_get(:@board)[0][5] = Board::PLAYER_TWO_TOKEN
        board.instance_variable_get(:@board)[1][4] = Board::PLAYER_TWO_TOKEN
        board.instance_variable_get(:@board)[2][3] = Board::PLAYER_TWO_TOKEN
        board.instance_variable_get(:@board)[3][2] = Board::PLAYER_TWO_TOKEN
        expect(board.win_status).to eq(:player_two)
      end
    end

    context 'when there are four player_ones in a row diagonally from the top spot in the fourth column' do
      it 'returns :player_one' do
        board.instance_variable_get(:@board)[3][5] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[4][4] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[5][3] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[6][2] = Board::PLAYER_ONE_TOKEN
        expect(board.win_status).to eq(:player_one)
      end
    end

    context 'when there are four player_ones in a row diagonally from the fourth row, fourth column spot' do
      it 'returns :player_one' do
        board.instance_variable_get(:@board)[3][3] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[4][2] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[5][1] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[6][0] = Board::PLAYER_ONE_TOKEN
        expect(board.win_status).to eq(:player_one)
      end
    end

    context 'when there are only three in a row diagonally' do
      it 'returns :no_win_yet' do
        board.instance_variable_get(:@board)[3][5] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[4][4] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[5][3] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[6][1] = Board::PLAYER_ONE_TOKEN
        expect(board.win_status).to eq(:no_win_yet)
      end
    end

    context 'when there are four Board::player_two in a row diagonally from the top right spot' do
      it 'returns :player_two' do
        board.instance_variable_get(:@board)[6][5] = Board::PLAYER_TWO_TOKEN
        board.instance_variable_get(:@board)[5][4] = Board::PLAYER_TWO_TOKEN
        board.instance_variable_get(:@board)[4][3] = Board::PLAYER_TWO_TOKEN
        board.instance_variable_get(:@board)[3][2] = Board::PLAYER_TWO_TOKEN
        expect(board.win_status).to eq(:player_two)
      end
    end

    context 'when there are four player_ones in a row diagonally from the top spot in the fourth column' do
      it 'returns :player_one' do
        board.instance_variable_get(:@board)[3][5] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[2][4] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[1][3] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[0][2] = Board::PLAYER_ONE_TOKEN
        expect(board.win_status).to eq(:player_one)
      end
    end

    context 'when there are four player_ones in a row diagonally from the fourth row, fourth column spot' do
      it 'returns :player_one' do
        board.instance_variable_get(:@board)[3][3] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[2][2] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[1][1] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[0][0] = Board::PLAYER_ONE_TOKEN
        expect(board.win_status).to eq(:player_one)
      end
    end

    context 'when there are only three in a row diagonally' do
      it 'returns :no_win_yet' do
        board.instance_variable_get(:@board)[3][5] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[4][4] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[5][3] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[6][1] = Board::PLAYER_ONE_TOKEN
        expect(board.win_status).to eq(:no_win_yet)
      end
    end
  end

  describe '#to_s' do
    context 'when no tokens are dropped' do
      it 'displays a blank board' do
        expect { puts(board) }.to output(<<-BOARD).to_stdout
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
    |  -  |  -  |  -  |  -  |  -  |  -  |  -  |
    |     |     |     |     |     |     |     |
    -------------------------------------------
    |  1  |  2  |  3  |  4  |  5  |  6  |  7  |

        BOARD
      end
    end

    context 'when two tokens are dropped (one of each kind) in the first column' do
      it 'displays a board with two tokens' do
        board.drop_token(Board::PLAYER_ONE_TOKEN, 0)
        board.drop_token(Board::PLAYER_TWO_TOKEN, 0)
        expect { puts(board) }.to output(<<-BOARD).to_stdout
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
    |  ⛔ |  -  |  -  |  -  |  -  |  -  |  -  |
    |     |     |     |     |     |     |     |
    |     |     |     |     |     |     |     |
    |  ♌ |  -  |  -  |  -  |  -  |  -  |  -  |
    |     |     |     |     |     |     |     |
    -------------------------------------------
    |  1  |  2  |  3  |  4  |  5  |  6  |  7  |

        BOARD
      end
    end
  end

  describe '#row_to_use' do
    context 'when the entire first column is full and a token is dropped in the first column' do
      it 'returns nil' do
        board.instance_variable_get(:@board)[0][0] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[0][1] = Board::PLAYER_TWO_TOKEN
        board.instance_variable_get(:@board)[0][2] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[0][3] = Board::PLAYER_TWO_TOKEN
        board.instance_variable_get(:@board)[0][4] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[0][5] = Board::PLAYER_TWO_TOKEN
        row_to_use_return = board.send(:row_to_use, 0)
        expect(row_to_use_return).to eq(nil)
      end
    end

    context 'when the board is empty and a token is dropped in the second column' do
      it 'returns 0' do
        row_to_use_return = board.send(:row_to_use, 1)
        expect(row_to_use_return).to eq(0)
      end
    end

    context 'when the seventh column is almost full and a token is dropped in the seventh column' do
      it 'returns 5' do
        board.instance_variable_get(:@board)[6][0] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[6][1] = Board::PLAYER_TWO_TOKEN
        board.instance_variable_get(:@board)[6][2] = Board::PLAYER_ONE_TOKEN
        board.instance_variable_get(:@board)[6][3] = Board::PLAYER_TWO_TOKEN
        board.instance_variable_get(:@board)[6][4] = Board::PLAYER_ONE_TOKEN
        row_to_use_return = board.send(:row_to_use, 6)
        expect(row_to_use_return).to eq(5)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
