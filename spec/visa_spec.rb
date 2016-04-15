require 'visa'

describe 'Visa' do
  describe '#name' do
    it 'returns name' do
      expect(Visa.new.name).to eq('VISA')
    end
  end
end
