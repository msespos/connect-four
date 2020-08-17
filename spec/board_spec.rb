# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/board.rb'

RSpec.describe Board do
  subject(:board) { Board.new }
  describe '@board' do
    context 'when the board is instantiated' do
      it 'is a 6 row board' do
        expect(board.instance_variable_get(:@board)[0].size).to eq(6)
      end

      it 'is a 7 column board' do
        expect(board.instance_variable_get(:@board).size).to eq(7)
      end

      it 'has "-" in the bottom left spot' do
        expect(board.instance_variable_get(:@board)[0][0]).to eq('-')
      end

      it 'has "-" in the bottom right spot' do
        expect(board.instance_variable_get(:@board)[6][0]).to eq('-')
      end
    end
  end

  describe '#drop_token' do
    context 'when the board is empty and a token is dropped in the first column' do
      it 'lands at the bottom of the first column' do
        board.drop_token('r', 0)
        expect(board.instance_variable_get(:@board)[0][0]).to eq('r')
      end
    end

    context 'when the bottom left spot is full and a token is dropped in the first column' do
      it 'lands at the second from the bottom spot of the first column' do
        board.instance_variable_get(:@board)[0][0] = 'r'
        board.drop_token('y', 0)
        expect(board.instance_variable_get(:@board)[0][1]).to eq('y')
      end
    end

    context 'when the bottom left spot is full and a token is dropped in the second column' do
      it 'lands at the bottom spot of the second column' do
        board.instance_variable_get(:@board)[0][0] = 'r'
        board.drop_token('y', 1)
        expect(board.instance_variable_get(:@board)[1][0]).to eq('y')
      end
    end

    context 'when the bottom two spots of the first column are full and a token is dropped in the first column' do
      it 'lands at the third from the bottom spot of the first column' do
        board.instance_variable_get(:@board)[0][0] = 'r'
        board.instance_variable_get(:@board)[0][1] = 'y'
        board.drop_token('r', 0)
        expect(board.instance_variable_get(:@board)[0][2]).to eq('r')
      end
    end

    context 'when the bottom three spots of the first column are full and a token is dropped in the first column' do
      it 'lands at the fourth from the bottom spot of the first column' do
        board.instance_variable_get(:@board)[0][0] = 'r'
        board.instance_variable_get(:@board)[0][1] = 'y'
        board.instance_variable_get(:@board)[0][2] = 'r'
        board.drop_token('y', 0)
        expect(board.instance_variable_get(:@board)[0][3]).to eq('y')
      end
    end

    context 'when the entire first column is full and a token is dropped in the first column' do
      it 'returns an error message' do
        board.instance_variable_get(:@board)[0][0] = 'r'
        board.instance_variable_get(:@board)[0][1] = 'y'
        board.instance_variable_get(:@board)[0][2] = 'r'
        board.instance_variable_get(:@board)[0][3] = 'y'
        board.instance_variable_get(:@board)[0][4] = 'r'
        board.instance_variable_get(:@board)[0][5] = 'y'
        drop_token_return = board.drop_token('r', 0)
        expect(drop_token_return).to eq(:error)
      end
    end
  end

  describe '#row_status' do
    context 'when there are four in a row along the bottom from columns 1 to 4' do
      it 'returns :win' do
        board.instance_variable_get(:@board)[0][0] = 'r'
        board.instance_variable_get(:@board)[1][0] = 'r'
        board.instance_variable_get(:@board)[2][0] = 'r'
        board.instance_variable_get(:@board)[3][0] = 'r'
        expect(board.row_status).to eq(:win)
      end
    end

    context 'when there are four in a row unrealistically "floating" along the top from columns 4 to 7' do
      it 'returns :win' do
        board.instance_variable_get(:@board)[3][5] = 'r'
        board.instance_variable_get(:@board)[4][5] = 'r'
        board.instance_variable_get(:@board)[5][5] = 'r'
        board.instance_variable_get(:@board)[6][5] = 'r'
        expect(board.row_status).to eq(:win)
      end
    end

    context 'when there only two in a row along the bottom in columns 2 and 3' do
      it 'returns :no_win_yet' do
        board.instance_variable_get(:@board)[0][0] = 'y'
        board.instance_variable_get(:@board)[1][0] = 'r'
        board.instance_variable_get(:@board)[2][0] = 'r'
        expect(board.row_status).to eq(:no_win_yet)
      end
    end

    context 'when there are only three in a row along the bottom in columns 5 through 7' do
      it 'returns :no_win_yet' do
        board.instance_variable_get(:@board)[0][0] = 'y'
        board.instance_variable_get(:@board)[1][0] = 'y'
        board.instance_variable_get(:@board)[4][0] = 'r'
        board.instance_variable_get(:@board)[5][0] = 'r'
        board.instance_variable_get(:@board)[6][0] = 'r'
        expect(board.row_status).to eq(:no_win_yet)
      end
    end

    context 'when there are no four-in-a-row situations on the board' do
      it 'returns :no_win_yet' do
        board.instance_variable_get(:@board)[0][0] = 'r'
        board.instance_variable_get(:@board)[1][0] = 'y'
        board.instance_variable_get(:@board)[2][0] = 'r'
        expect(board.row_status).to eq(:no_win_yet)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
