# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/board.rb'

RSpec.describe Board do
  subject(:board) { Board.new }
  describe '#board' do
    context 'when the board class is instantiated' do
      it 'generates a 6 row board' do
        expect(board.instance_variable_get(:@board)[0].size).to eq(6)
      end

      it 'generates a 7 column board' do
        expect(board.instance_variable_get(:@board).size).to eq(7)
      end

      it 'generates a board with "-" in the bottom left spot' do
        expect(board.instance_variable_get(:@board)[0][0]).to eq('-')
      end

      it 'generates a board with "-" in the bottom right spot' do
        expect(board.instance_variable_get(:@board)[6][0]).to eq('-')
      end
    end
  end

  describe '#drop_token' do
    context 'when the board is empty and a token is dropped in the first column' do
      it 'lands at the bottom of the first column' do
        board.drop_token(:red, 0)
        expect(board.instance_variable_get(:@board)[0][0]).to eq(:red)
      end
    end

    context 'when the bottom left spot is full and a token is dropped in the first column' do
      it 'lands at the second from the bottom spot of the first column' do
        board.instance_variable_get(:@board)[0][0] = :red
        board.drop_token(:yellow, 0)
        expect(board.instance_variable_get(:@board)[0][1]).to eq(:yellow)
      end
    end

    context 'when the bottom left spot is full and a token is dropped in the second column' do
      it 'lands at the bottom spot of the second column' do
        board.instance_variable_get(:@board)[0][0] = :red
        board.drop_token(:yellow, 1)
        expect(board.instance_variable_get(:@board)[1][0]).to eq(:yellow)
      end
    end

    context 'when the bottom two spots of the first column are full and a token is dropped in the first column' do
      it 'lands at the third from the bottom spot of the first column' do
        board.instance_variable_get(:@board)[0][0] = :red
        board.instance_variable_get(:@board)[0][1] = :yellow
        board.drop_token(:red, 0)
        expect(board.instance_variable_get(:@board)[0][2]).to eq(:red)
      end
    end

    context 'when the bottom three spots of the first column are full and a token is dropped in the first column' do
      it 'lands at the fourth from the bottom spot of the first column' do
        board.instance_variable_get(:@board)[0][0] = :red
        board.instance_variable_get(:@board)[0][1] = :yellow
        board.instance_variable_get(:@board)[0][2] = :red
        board.drop_token(:yellow, 0)
        expect(board.instance_variable_get(:@board)[0][3]).to eq(:yellow)
      end
    end

    context 'when the entire first column is full and a token is dropped in the first column' do
      it 'returns an error message' do
        board.instance_variable_get(:@board)[0][0] = :red
        board.instance_variable_get(:@board)[0][1] = :yellow
        board.instance_variable_get(:@board)[0][2] = :red
        board.instance_variable_get(:@board)[0][3] = :yellow
        board.instance_variable_get(:@board)[0][4] = :red
        board.instance_variable_get(:@board)[0][5] = :yellow
        drop_token_return = board.drop_token(:red, 0)
        expect(drop_token_return).to eq(:error)
      end
    end
  end

  describe '#board_status' do
    context 'when there are four red in a row along the bottom from columns 1 to 4' do
      it 'returns :red' do
        board.instance_variable_get(:@board)[0][0] = :red
        board.instance_variable_get(:@board)[1][0] = :red
        board.instance_variable_get(:@board)[2][0] = :red
        board.instance_variable_get(:@board)[3][0] = :red
        expect(board.board_status).to eq(:red)
      end
    end

    context 'when there are four red in a row placed along the top from columns 4 to 7' do
      it 'returns :red' do
        board.instance_variable_get(:@board)[3][5] = :red
        board.instance_variable_get(:@board)[4][5] = :red
        board.instance_variable_get(:@board)[5][5] = :red
        board.instance_variable_get(:@board)[6][5] = :red
        expect(board.board_status).to eq(:red)
      end
    end

    context 'when there only two in a row along the bottom in columns 2 and 3' do
      it 'returns :no_win_yet' do
        board.instance_variable_get(:@board)[0][0] = :yellow
        board.instance_variable_get(:@board)[1][0] = :red
        board.instance_variable_get(:@board)[2][0] = :red
        expect(board.board_status).to eq(:no_win_yet)
      end
    end

    context 'when there are only three in a row along the bottom in columns 5 through 7' do
      it 'returns :no_win_yet' do
        board.instance_variable_get(:@board)[0][0] = :yellow
        board.instance_variable_get(:@board)[1][0] = :yellow
        board.instance_variable_get(:@board)[4][0] = :red
        board.instance_variable_get(:@board)[5][0] = :red
        board.instance_variable_get(:@board)[6][0] = :red
        expect(board.board_status).to eq(:no_win_yet)
      end
    end

    context 'when there are four red in a column along the left from rows 1 to 4' do
      it 'returns :red' do
        board.instance_variable_get(:@board)[0][0] = :red
        board.instance_variable_get(:@board)[0][1] = :red
        board.instance_variable_get(:@board)[0][2] = :red
        board.instance_variable_get(:@board)[0][3] = :red
        board.instance_variable_get(:@board)[1][0] = :yellow
        board.instance_variable_get(:@board)[1][1] = :yellow
        board.instance_variable_get(:@board)[1][2] = :yellow
        expect(board.board_status).to eq(:red)
      end
    end

    context 'when there are four yellow in a column unrealistically placed from rows 4 to 7' do
      it 'returns :yellow' do
        board.instance_variable_get(:@board)[5][0] = :red
        board.instance_variable_get(:@board)[5][1] = :yellow
        board.instance_variable_get(:@board)[5][2] = :yellow
        board.instance_variable_get(:@board)[5][3] = :yellow
        board.instance_variable_get(:@board)[5][4] = :yellow
        board.instance_variable_get(:@board)[5][5] = :yellow
        expect(board.board_status).to eq(:yellow)
      end
    end

    context 'when there only two in a column along the left side in rows 2 and 3' do
      it 'returns :no_win_yet' do
        board.instance_variable_get(:@board)[0][0] = :yellow
        board.instance_variable_get(:@board)[1][0] = :yellow
        board.instance_variable_get(:@board)[0][1] = :red
        board.instance_variable_get(:@board)[0][2] = :red
        expect(board.board_status).to eq(:no_win_yet)
      end
    end

    context 'when there are only three in a column placed along the left side in rows 5 through 7' do
      it 'returns :no_win_yet' do
        board.instance_variable_get(:@board)[1][0] = :yellow
        board.instance_variable_get(:@board)[2][0] = :yellow
        board.instance_variable_get(:@board)[3][0] = :yellow
        board.instance_variable_get(:@board)[4][0] = :red
        board.instance_variable_get(:@board)[5][0] = :red
        board.instance_variable_get(:@board)[6][0] = :red
        expect(board.board_status).to eq(:no_win_yet)
      end
    end

    context 'when there are four yellow in a row diagonally from the top left spot' do
      it 'returns :yellow' do
        board.instance_variable_get(:@board)[0][5] = :yellow
        board.instance_variable_get(:@board)[1][4] = :yellow
        board.instance_variable_get(:@board)[2][3] = :yellow
        board.instance_variable_get(:@board)[3][2] = :yellow
        expect(board.board_status).to eq(:yellow)
      end
    end

    context 'when there are four red in a row diagonally from the top spot in the fourth column' do
      it 'returns :red' do
        board.instance_variable_get(:@board)[3][5] = :red
        board.instance_variable_get(:@board)[4][4] = :red
        board.instance_variable_get(:@board)[5][3] = :red
        board.instance_variable_get(:@board)[6][2] = :red
        expect(board.board_status).to eq(:red)
      end
    end

    context 'when there are four red in a row diagonally from the fourth row, fourth column spot' do
      it 'returns :red' do
        board.instance_variable_get(:@board)[3][3] = :red
        board.instance_variable_get(:@board)[4][2] = :red
        board.instance_variable_get(:@board)[5][1] = :red
        board.instance_variable_get(:@board)[6][0] = :red
        expect(board.board_status).to eq(:red)
      end
    end

    context 'when there are only three in a row diagonally' do
      it 'returns :no_win_yet' do
        board.instance_variable_get(:@board)[3][5] = :red
        board.instance_variable_get(:@board)[4][4] = :red
        board.instance_variable_get(:@board)[5][3] = :red
        board.instance_variable_get(:@board)[6][1] = :red
        expect(board.board_status).to eq(:no_win_yet)
      end
    end

    context 'when there are four yellow in a row diagonally from the top right spot' do
      it 'returns :yellow' do
        board.instance_variable_get(:@board)[6][5] = :yellow
        board.instance_variable_get(:@board)[5][4] = :yellow
        board.instance_variable_get(:@board)[4][3] = :yellow
        board.instance_variable_get(:@board)[3][2] = :yellow
        expect(board.board_status).to eq(:yellow)
      end
    end

    context 'when there are four red in a row diagonally from the top spot in the fourth column' do
      it 'returns :red' do
        board.instance_variable_get(:@board)[3][5] = :red
        board.instance_variable_get(:@board)[2][4] = :red
        board.instance_variable_get(:@board)[1][3] = :red
        board.instance_variable_get(:@board)[0][2] = :red
        expect(board.board_status).to eq(:red)
      end
    end

    context 'when there are four red in a row diagonally from the fourth row, fourth column spot' do
      it 'returns :red' do
        board.instance_variable_get(:@board)[3][3] = :red
        board.instance_variable_get(:@board)[2][2] = :red
        board.instance_variable_get(:@board)[1][1] = :red
        board.instance_variable_get(:@board)[0][0] = :red
        expect(board.board_status).to eq(:red)
      end
    end

    context 'when there are only three in a row diagonally' do
      it 'returns :no_win_yet' do
        board.instance_variable_get(:@board)[3][5] = :red
        board.instance_variable_get(:@board)[4][4] = :red
        board.instance_variable_get(:@board)[5][3] = :red
        board.instance_variable_get(:@board)[6][1] = :red
        expect(board.board_status).to eq(:no_win_yet)
      end
    end

    context 'viewing the board' do
      it 'displays the board' do
        board.drop_token('$', 0)
        board.drop_token('@', 0)
        board.drop_token('$', 5)
        board.drop_token('@', 0)
        board.drop_token('$', 4)
        board.drop_token('@', 0)
        board.drop_token('$', 5)
        board.drop_token('@', 1)
        board.drop_token('$', 5)
        puts board.to_s
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
