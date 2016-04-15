require 'amex'

describe 'Amex' do
  describe '#name' do
    it 'returns name' do
      expect(Amex.new.name).to eq('AMEX')
    end
  end
end
