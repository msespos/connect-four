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

      it 'has "-" in the bottow right spot' do
        expect(board.instance_variable_get(:@board)[6][0]).to eq("-")
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
