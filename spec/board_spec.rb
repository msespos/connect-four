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
        expect(board.instance_variable_get(:@board)[0][0]).to eq("-")
      end
    
      it 'has "-" in the bottom right spot' do
        expect(board.instance_variable_get(:@board)[6][0]).to eq("-")
      end
    end
  end
  
  describe '#drop_token' do
    context 'when the board is empty and a token is dropped in the first column' do
      it 'the token lands at the bottom of the first column' do
        board.drop_token('r', 1)
        expect(board.instance_variable_get(:@board)[0][0]).to eq('r')
      end
    end

    context 'when the bottom left spot is full and a token is dropped in the first column' do
      it 'the token lands at the second from the bottom spot of the first column' do
        board.instance_variable_get(:@board)[0][0] = 'r'
        board.drop_token('y', 1)
        expect(board.instance_variable_get(:@board)[0][1]).to eq('y')
      end
    end

    context 'when the bottom left spot is full and a token is dropped in the second column' do
      it 'the token lands at the bottom spot of the second column' do
        board.instance_variable_get(:@board)[0][0] = 'r'
        board.drop_token('y', 2)
        expect(board.instance_variable_get(:@board)[1][0]).to eq('y')
      end
    end

    context 'when the bottom two spots of the first column are full and a token is dropped in the first column' do
      it 'the token lands at the third from the bottom spot of the first column' do
        board.instance_variable_get(:@board)[0][0] = 'r'
        board.instance_variable_get(:@board)[0][1] = 'y'
        board.drop_token('r', 1)
        expect(board.instance_variable_get(:@board)[0][2]).to eq('r')
      end
    end

    context 'when the bottom three spots of the first column are full and a token is dropped in the first column' do
      it 'the token lands at the fourth from the bottom spot of the first column' do
        board.instance_variable_get(:@board)[0][0] = 'r'
        board.instance_variable_get(:@board)[0][1] = 'y'
        board.instance_variable_get(:@board)[0][2] = 'r'
        board.drop_token('y', 1)
        expect(board.instance_variable_get(:@board)[0][3]).to eq('y')
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
