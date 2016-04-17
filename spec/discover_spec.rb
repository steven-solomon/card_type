require 'discover'

describe 'Discover' do
  let(:card_number) { '6011111111111117' }
  subject {Discover.new(card_number)}

  describe '#name' do
    it 'returns name' do
      expect(subject.name).to eq('Discover')
    end
  end

  describe '#charge' do
    it 'calls discover service' do
      amount = 10.00
      receipt = double(:receipt)
      expect(DiscoverService)
        .to receive(:hold)
              .with(card_number, amount)
              .and_return(receipt)

      expect(BatchBilling)
        .to receive(:enqueue)
              .with(receipt)

      subject.charge(amount)
    end
  end

  describe '#return' do
    it 'raise error' do
      receipt = double(:receipt)
      expect { subject.return(receipt) }.to raise_error('Error: returns not valid for Discover')
    end
  end
end
