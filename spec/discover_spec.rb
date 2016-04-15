require 'discover'

describe 'Discover' do
  describe '#name' do
    it 'returns name' do
      expect(Discover.new.name).to eq('Discover')
    end
  end
end
