require 'unknown_card'

describe 'UnknownCard' do
  describe '#name' do
    it 'returns name' do
      expect(UnknownCard.new.name).to eq('Unknown')
    end
  end
end
