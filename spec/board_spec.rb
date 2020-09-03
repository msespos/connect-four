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
        board.drop_token(Board::LEO_TOKEN, 0)
        expect(board.instance_variable_get(:@board)[0][0]).to eq(Board::LEO_TOKEN)
      end
    end

    context 'when the bottom left spot is full and a token is dropped in the first column' do
      it 'lands at the second from the bottom spot of the first column' do
        board.instance_variable_get(:@board)[0][0] = Board::LEO_TOKEN
        board.drop_token(Board::DO_NOT_ENTER_TOKEN, 0)
        expect(board.instance_variable_get(:@board)[0][1]).to eq(Board::DO_NOT_ENTER_TOKEN)
      end
    end

    context 'when the bottom left spot is full and a token is dropped in the second column' do
      it 'lands at the bottom spot of the second column' do
        board.instance_variable_get(:@board)[0][0] = Board::LEO_TOKEN
        board.drop_token(Board::DO_NOT_ENTER_TOKEN, 1)
        expect(board.instance_variable_get(:@board)[1][0]).to eq(Board::DO_NOT_ENTER_TOKEN)
      end
    end

    context 'when the bottom two spots of the first column are full and a token is dropped in the first column' do
      it 'lands at the third from the bottom spot of the first column' do
        board.instance_variable_get(:@board)[0][0] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[0][1] = Board::DO_NOT_ENTER_TOKEN
        board.drop_token(Board::LEO_TOKEN, 0)
        expect(board.instance_variable_get(:@board)[0][2]).to eq(Board::LEO_TOKEN)
      end
    end

    context 'when the bottom three spots of the first column are full and a token is dropped in the first column' do
      it 'lands at the fourth from the bottom spot of the first column' do
        board.instance_variable_get(:@board)[0][0] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[0][1] = Board::DO_NOT_ENTER_TOKEN
        board.instance_variable_get(:@board)[0][2] = Board::LEO_TOKEN
        board.drop_token(Board::DO_NOT_ENTER_TOKEN, 0)
        expect(board.instance_variable_get(:@board)[0][3]).to eq(Board::DO_NOT_ENTER_TOKEN)
      end
    end
  end

  describe '#row_to_use' do
    context 'when the entire first column is full and a token is dropped in the first column' do
      it 'returns an error message' do
        board.instance_variable_get(:@board)[0][0] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[0][1] = Board::DO_NOT_ENTER_TOKEN
        board.instance_variable_get(:@board)[0][2] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[0][3] = Board::DO_NOT_ENTER_TOKEN
        board.instance_variable_get(:@board)[0][4] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[0][5] = Board::DO_NOT_ENTER_TOKEN
        row_to_use_return = board.row_to_use(0)
        expect(row_to_use_return).to eq(:error)
      end
    end
  end

  describe '#win_status' do
    context 'when there are four leos in a row along the bottom from columns 1 to 4' do
      it 'returns :leo' do
        board.instance_variable_get(:@board)[0][0] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[1][0] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[2][0] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[3][0] = Board::LEO_TOKEN
        expect(board.win_status).to eq(:leo)
      end
    end

    context 'when there are four leos in a row placed along the top from columns 4 to 7' do
      it 'returns :leo' do
        board.instance_variable_get(:@board)[3][5] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[4][5] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[5][5] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[6][5] = Board::LEO_TOKEN
        expect(board.win_status).to eq(:leo)
      end
    end

    context 'when there only two in a row along the bottom in columns 2 and 3' do
      it 'returns :no_win_yet' do
        board.instance_variable_get(:@board)[0][0] = Board::DO_NOT_ENTER_TOKEN
        board.instance_variable_get(:@board)[1][0] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[2][0] = Board::LEO_TOKEN
        expect(board.win_status).to eq(:no_win_yet)
      end
    end

    context 'when there are only three in a row along the bottom in columns 5 through 7' do
      it 'returns :no_win_yet' do
        board.instance_variable_get(:@board)[0][0] = Board::DO_NOT_ENTER_TOKEN
        board.instance_variable_get(:@board)[1][0] = Board::DO_NOT_ENTER_TOKEN
        board.instance_variable_get(:@board)[4][0] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[5][0] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[6][0] = Board::LEO_TOKEN
        expect(board.win_status).to eq(:no_win_yet)
      end
    end

    context 'when there are four leo in a column along the left from rows 1 to 4' do
      it 'returns :leo' do
        board.instance_variable_get(:@board)[0][0] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[0][1] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[0][2] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[0][3] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[1][0] = Board::DO_NOT_ENTER_TOKEN
        board.instance_variable_get(:@board)[1][1] = Board::DO_NOT_ENTER_TOKEN
        board.instance_variable_get(:@board)[1][2] = Board::DO_NOT_ENTER_TOKEN
        expect(board.win_status).to eq(:leo)
      end
    end

    context 'when there are four do_not_enter in a column unrealistically placed from rows 4 to 7' do
      it 'returns :do_not_enter' do
        board.instance_variable_get(:@board)[5][0] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[5][1] = Board::DO_NOT_ENTER_TOKEN
        board.instance_variable_get(:@board)[5][2] = Board::DO_NOT_ENTER_TOKEN
        board.instance_variable_get(:@board)[5][3] = Board::DO_NOT_ENTER_TOKEN
        board.instance_variable_get(:@board)[5][4] = Board::DO_NOT_ENTER_TOKEN
        board.instance_variable_get(:@board)[5][5] = Board::DO_NOT_ENTER_TOKEN
        expect(board.win_status).to eq(:do_not_enter)
      end
    end

    context 'when there only two in a column along the left side in rows 2 and 3' do
      it 'returns :no_win_yet' do
        board.instance_variable_get(:@board)[0][0] = Board::DO_NOT_ENTER_TOKEN
        board.instance_variable_get(:@board)[1][0] = Board::DO_NOT_ENTER_TOKEN
        board.instance_variable_get(:@board)[0][1] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[0][2] = Board::LEO_TOKEN
        expect(board.win_status).to eq(:no_win_yet)
      end
    end

    context 'when there are only three in a column placed along the left side in rows 5 through 7' do
      it 'returns :no_win_yet' do
        board.instance_variable_get(:@board)[1][0] = Board::DO_NOT_ENTER_TOKEN
        board.instance_variable_get(:@board)[2][0] = Board::DO_NOT_ENTER_TOKEN
        board.instance_variable_get(:@board)[3][0] = Board::DO_NOT_ENTER_TOKEN
        board.instance_variable_get(:@board)[4][0] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[5][0] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[6][0] = Board::LEO_TOKEN
        expect(board.win_status).to eq(:no_win_yet)
      end
    end

    context 'when there are four Board::DO_NOT_ENTER in a row diagonally from the top left spot' do
      it 'returns :do_not_enter' do
        board.instance_variable_get(:@board)[0][5] = Board::DO_NOT_ENTER_TOKEN
        board.instance_variable_get(:@board)[1][4] = Board::DO_NOT_ENTER_TOKEN
        board.instance_variable_get(:@board)[2][3] = Board::DO_NOT_ENTER_TOKEN
        board.instance_variable_get(:@board)[3][2] = Board::DO_NOT_ENTER_TOKEN
        expect(board.win_status).to eq(:do_not_enter)
      end
    end

    context 'when there are four leo in a row diagonally from the top spot in the fourth column' do
      it 'returns :leo' do
        board.instance_variable_get(:@board)[3][5] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[4][4] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[5][3] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[6][2] = Board::LEO_TOKEN
        expect(board.win_status).to eq(:leo)
      end
    end

    context 'when there are four leo in a row diagonally from the fourth row, fourth column spot' do
      it 'returns :leo' do
        board.instance_variable_get(:@board)[3][3] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[4][2] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[5][1] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[6][0] = Board::LEO_TOKEN
        expect(board.win_status).to eq(:leo)
      end
    end

    context 'when there are only three in a row diagonally' do
      it 'returns :no_win_yet' do
        board.instance_variable_get(:@board)[3][5] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[4][4] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[5][3] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[6][1] = Board::LEO_TOKEN
        expect(board.win_status).to eq(:no_win_yet)
      end
    end

    context 'when there are four Board::DO_NOT_ENTER in a row diagonally from the top right spot' do
      it 'returns :do_not_enter' do
        board.instance_variable_get(:@board)[6][5] = Board::DO_NOT_ENTER_TOKEN
        board.instance_variable_get(:@board)[5][4] = Board::DO_NOT_ENTER_TOKEN
        board.instance_variable_get(:@board)[4][3] = Board::DO_NOT_ENTER_TOKEN
        board.instance_variable_get(:@board)[3][2] = Board::DO_NOT_ENTER_TOKEN
        expect(board.win_status).to eq(:do_not_enter)
      end
    end

    context 'when there are four leo in a row diagonally from the top spot in the fourth column' do
      it 'returns :leo' do
        board.instance_variable_get(:@board)[3][5] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[2][4] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[1][3] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[0][2] = Board::LEO_TOKEN
        expect(board.win_status).to eq(:leo)
      end
    end

    context 'when there are four leo in a row diagonally from the fourth row, fourth column spot' do
      it 'returns :leo' do
        board.instance_variable_get(:@board)[3][3] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[2][2] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[1][1] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[0][0] = Board::LEO_TOKEN
        expect(board.win_status).to eq(:leo)
      end
    end

    context 'when there are only three in a row diagonally' do
      it 'returns :no_win_yet' do
        board.instance_variable_get(:@board)[3][5] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[4][4] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[5][3] = Board::LEO_TOKEN
        board.instance_variable_get(:@board)[6][1] = Board::LEO_TOKEN
        expect(board.win_status).to eq(:no_win_yet)
      end
    end

    context 'viewing the board' do
      it 'displays the board' do
        board.drop_token(Board::LEO_TOKEN, 0)
        board.drop_token(Board::DO_NOT_ENTER_TOKEN, 0)
        puts
        puts
        puts board.to_s
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
