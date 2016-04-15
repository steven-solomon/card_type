require 'mastercard'

describe 'Mastercard' do
  describe '#name' do
    it 'returns name' do
      expect(Mastercard.new.name).to eq('Mastercard')
    end
  end
end
